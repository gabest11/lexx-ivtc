<?php

if(!file_exists($argv[1])) die('check file name');

$title = preg_replace('/\\.[^\\.]+$/i', '', $argv[1]);

$force = isset($argv[3]) && $argv[3] == 'force';

$cthresh = 9;
$MI = 80;
$PP = 6;

$tfmframes = [];
$tdecframes = [];
$ovrframes = [];
$ovrscenes = [];

function init()
{
	global $title;
	global $ovrframes;
	global $ovrscenes;

	$ovrframes = [];
	$ovrscenes = [];
	
	foreach(explode("\n", file_get_contents("$title-tfm-ovr.txt")) as $row)
	{
		$row = trim($row);
		
		$s = $row;

		if(($i = strpos($row, '#')) !== false)
		{
			$s = trim(substr($row, 0, $i));
		}

		if(preg_match('/^([0-9]+)(,([0-9]+))? +([\\+\\-]+)$/i', $s, $m))
		{
			if(is_numeric($m[3])) 
			{
				if((int)$m[1] >= (int)$m[3]) {echo 'check row '.$row.PHP_EOL;}
			}
			
			if(empty($m[3])) $m[3] = $m[1];
		
			for($i = (int)$m[1], $j = (int)$m[3], $k = 0; $i <= $j; $i++)
			{
				//if(isset($ovrframes[$i]['deint'])) die($row);
				
				$ovrframes[$i]['deint']['value'] = $m[4][$k];
				$ovrframes[$i]['deint']['row'] = $row;
		
				if(++$k == strlen($m[4])) $k = 0;
			}
		}
		else if(preg_match('/^([0-9]+)(,([0-9]+))? +i +([0-9]+)$/i', $s, $m))
		{
			if(empty($m[3])) $m[3] = $m[1];

			for($i = (int)$m[1], $j = (int)$m[3]; $i <= $j; $i++)
			{
				$ovrframes[$i]['MI']['value'] = $m[4];
				$ovrframes[$i]['MI']['row'] = $row;
			}
		}
		else if(preg_match('/^([0-9]+)(,([0-9]+))? +(Q|PP) +([0-9]+)$/i', $s, $m))
		{
			if(empty($m[3])) $m[3] = $m[1];

			for($i = (int)$m[1], $j = (int)$m[3]; $i <= $j; $i++)
			{
				$ovrframes[$i]['Q']['value'] = $m[5];
				$ovrframes[$i]['Q']['row'] = $row;
			}
		}
		else if(preg_match('/^([0-9]+)(,([0-9]+))?( +([cpbnuhl]+))?$/i', $s, $m))
		{
			if(isset($m[3]) && is_numeric($m[3])) 
			{
				if((int)$m[1] >= (int)$m[3]) {echo 'check row '.$row.PHP_EOL;}
				
				// should be one for every "scene change", but we basically mark every single one of them
				
				$ovrframes[$m[1]]['first'] = true;
				$ovrframes[$m[3]]['last'] = true;
			}
			
			if(empty($m[3])) $m[3] = $m[1];
			
			if(empty($m[5])) continue; //$m[5] = '';
			
			$scene = ['s' => (int)$m[1], 'e' => (int)$m[3], 't' => $m[5], 'row' => $row];
			
			$ovrscenes[] = $scene;
			
			if(!empty($m[5]))
			for($i = (int)$m[1], $j = (int)$m[3], $k = 0; $i <= $j; $i++)
			{
				if(isset($ovrframes[$i]['type'])) die($row);
				
				$value = $m[5][$k];
				
				$ovrframes[$i]['type']['value'] = $value;
				$ovrframes[$i]['type']['row'] = $row;
				$ovrframes[$i]['type']['scene'] = $scene;

				$ovrframes[$i]['first_pb'] = isset($ovrframes[$i]['first']) && array_search($value, ['p','b']) !== false;
				$ovrframes[$i]['last_un'] = isset($ovrframes[$i]['last']) && array_search($value, ['u','n']) !== false;
		
				if(++$k == strlen($m[5])) $k = 0;
			}
		}
	}
	
	foreach(explode("\n", file_get_contents("$title-tdec-ovr.txt")) as $row)
	{
		$row = trim($row);

		$s = $row;
		
		if(($i = strpos($row, '#')) !== false)
		{
			$s = trim(substr($row, 0, $i));
		}
		
		if(preg_match('/^([0-9]+)(,([0-9]+))? +([fvc])$/i', $s, $m))
		{
			if(isset($m[3]) && is_numeric($m[3])) 
			{
				if((int)$m[1] >= (int)$m[3]) {echo 'check row '.$row.PHP_EOL;}
			}
			
			if(empty($m[3])) $m[3] = $m[1];

			if($m[4] == 'c') {echo 'check row '.$row.PHP_EOL;}
			
			for($i = (int)$m[1], $j = (int)$m[3]; $i <= $j; $i++)
			{
				$ovrframes[$i]['rate'] = $m[4];
			}
		}
		else if(preg_match('/^([0-9]+)(,([0-9]+))? +([\\+\\-]+)$/i', $s, $m))
		{
			if(is_numeric($m[3])) 
			{
				if((int)$m[1] >= (int)$m[3]) {echo 'check row '.$row.PHP_EOL;}
			}
			
			if(empty($m[3])) $m[3] = $m[1];
		
			for($i = (int)$m[1], $j = (int)$m[3], $k = 0; $i <= $j; $i++)
			{
				$ovrframes[$i]['dec']['value'] = $m[4][$k];
				$ovrframes[$i]['dec']['row'] = $row;
		
				if(++$k == strlen($m[4])) $k = 0;
			}
		}
	}
}

function sanitycheck1()
{
	#TODO: scene begins with p/b, ends on u/n and blended

	global $title;
	global $tfmframes;
	global $ovrframes;
	global $ovrscenes;

	$bogusframes = [];
	$bogusscenes = [];
	$bogussc = [];

	$tfmframes = [];

	foreach(explode("\n", file_get_contents("$title-tfm.txt")) as $row)
	{
		$row = trim($row);

		if(!preg_match('/^([0-9]+) +([cpbnuhl]) +([\\+\\-]) +\\[([\-0-9]+)\\] +(\\(([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+)\\))?/i', $row, $m)) continue;
		
		$i = (int)$m[1];

		$tfmframes[$i] = ['type' => $m[2], 'deint' => $m[3], 'mic' => (int)$m[4], 'dup' => ''];

		if(!empty($m[5]))
		{
			$mics = [];
			
			$mics['p'] = (int)$m[6];
			$mics['c'] = (int)$m[7];
			$mics['n'] = (int)$m[8];
			$mics['b'] = (int)$m[9];
			$mics['u'] = (int)$m[10];
			
			if($mics['c'] < 20)
			{
				$pb = $mics['p'] + $mics['b'];
				$nu = $mics['n'] + $mics['u'];
				$pnd = $mics['p'] - $mics['n'];
				$bud = $mics['b'] - $mics['u'];

				if($pb < 30 && $pb < $nu && $nu > 20 || $pnd < -200 && $bud < -200)
				{
					$tfmframes[$i]['dup'] = 'p';
					
					if($i > 0 && $tfmframes[$i - 1]['dup'] != 'n')
					{
						$tfmframes[$i]['dup'] = 'c';
					}
				}
				else if($nu < 30 && $nu < $pb && $pb > 20 || $pnd > 200 && $bud > 200)
				{
					$tfmframes[$i]['dup'] = 'n';
					
					if($i > 0 && $tfmframes[$i - 1]['dup'] == 'n')
					{
						$tfmframes[$i - 1]['dup'] = 'c';
					}
				}
				else
				{
					$tfmframes[$i]['dup'] = 'c';
					
					if($i > 0 && $tfmframes[$i - 1]['dup'] == 'n')
					{
						$tfmframes[$i - 1]['dup'] = 'c';
					}
				}
			}

			$tfmframes[$i]['mics'] = $mics;
			
			$mint = 'c';
			$minv = $mics[$mint];
			
			foreach($mics as $t => $mic) 
			{
				if($mic < $minv)
				{
					$mint = $t; 
					$minv = $mic;
				}
			}

			$tfmframes[$i]['micmin'] = ['t' => $mint, 'v' => $minv];
		}
	}

#foreach($tfmframes as $i => $f) echo $i.' '.$f['dup'].PHP_EOL;
#exit;

	foreach($tfmframes as $i => $tfm)
	{
		if(!isset($ovrframes[$i])) continue; #TODO: warn about undefined ranges
	
		$f = $ovrframes[$i];
				
		if(!isset($f['type'])) continue;

		if($tfm['deint'] == '-')
		{
			// first frame p/b or last u/n and not deinterlaced
		
			if((!empty($f['first_pb']) || !empty($f['last_un'])) && isset($f['deint']) && $f['deint']['value'] == '-')
			{
				$bogusframes[$i] = ['f' => $f, 'note' => 'pb/un at sc -'];
			}
/*
			else if($tfm['mic'] >= 30 && !isset($f['MI']) && !isset($f['deint']))
			{
				$bogusframes[$i] = ['f' => $f, 'note' => ''];
			}
*/
		}
		else if($tfm['deint'] == '+' || $tfm['mic'] >= 60)
		{
			// ignore:
			// - first of the scene (maybe check if it's type c, those are often single field and look ugly)
			// - indirectly deinterlaced by MI level
			// - directly deinterlaced
			// - h/l frames that have Q set to 4/7 (nnedi3)
			
			//if(isset($f['first']) && array_search(['p','b'], $f['type']['value']) !== false
			
			$sc = !empty($f['first_pb']) || !empty($f['last_un']);
			$blend = isset($f['Q']) && ($f['Q']['value'] == 2 || $f['Q']['value'] == 5);
			$nnedi3 = isset($f['Q']) && ($f['Q']['value'] == 4 || $f['Q']['value'] == 7);
			$deintovr = isset($f['deint']) && $f['deint']['value'] == '+';
			$t = $f['type']['value'];
			
			if(!($sc || isset($f['MI']) || $deintovr || $nnedi3 && ($t == 'l' || $t == 'h')))
			{
				// still auto-deinterlaced by TFM, examine the reason

				$bogusframes[$i] = ['f' => $f, 'note' => 'auto-deint or MIC high '.$tfm['mic']];
			}
			else if($sc && $blend)
			{
				// blended first/last half frame
				
				$bogusframes[$i] = ['f' => $f, 'note' => 'first/last blended'];
			}
			else if(!$sc && ($nnedi3 || !isset($f['Q'])) && ($t == 'u' || $t == 'n') && !(isset($f['dec']) && $f['dec']['value'] == '-'))
			{
				$bogusframes[$i] = ['f' => $f, 'note' => 'deinterlaced the wrong field probably'.(isset($f['Q']) ? ' Q = '.$f['Q']['value'] : '')];
			}
		}
		
		if(!isset($f['first'])
		&& $tfm['micmin']['t'] != $tfm['type']
		&& $tfm['type'] == 'c' && $tfm['micmin']['t'] == 'p'
//		&& ($tfm['type'] == 'c' || $tfm['type'] == 'p')
//		&& ($tfm['micmin']['t'] == 'c' || $tfm['micmin']['t'] == 'p')
		&& $tfm['micmin']['v'] < 20 && $tfm['mics'][$tfm['type']] > 50)
		{
			// recommendation by tfm is different
			
print_r([$i, $tfm, $f]);
			$bogusframes[$i] = ['f' => $f, 'note' => $tfm['micmin']['t'].'?'];
		}
	}
	
	//
	
	foreach($ovrframes as $i => $f)
	{
		if(isset($f['rate']) && $f['rate'] == 'v' && isset($f['dec']['value']) && $f['dec']['value'] == '-')
		{
			// TDecimate will drop - regardless the v flag

			$bogusframes[$i] = ['f' => $f, 'note' => 'v dropped'];
		}
	}
	
	//
	
	foreach($ovrscenes as $scene)
	{
		$mics = [];
		$count = [];
		
		$cycle = strlen($scene['t']);
		
		if($cycle <= 1) $cycle = 5;
		
		for($k = 0; $k < $cycle; $k++)
		{
			$mics[$k] = ['p' => 0, 'c' => 0, 'n' => 0, 'b' => 0, 'u' => 0];
			$count[$k] = 1;
		}
			
		for($i = $scene['s'], $j = $scene['e'], $k = 0; $i <= $j; $i++)
		{
			foreach($tfmframes[$i]['mics'] as $t => $v)
			{
				$mics[$k][$t] += $v;
			}
			
			$count[$k]++;
		
			if(++$k == $cycle) $k = 0;
		}

		foreach($mics as $k => $mic)
		{
			asort($mic, SORT_NUMERIC);
			
			foreach($mic as $t => $v)
			{
				$mic[$t] /= $count[$k];
			}
			
			$mics[$k] = $mic;
		}		
/*
		// best values each position
		
		$suggested = '';
		
		for($k = 0; $k < $cycle; $k++)
		{
			$mint = 'c';
			$minv = $mics[$k][$mint];

			foreach($mics[$k] as $t => $v)
			{
				if($t == 'u' || $t == 'b' || $t == 'n') continue;
				
				if($v < $minv && $minv > 1)
				{
					$mint = $t; 
					$minv = $v;
				}
			}
			
			$suggested .= $mint;
		}
		
		#echo $scene['row'].PHP_EOL;
		#print_r($mics);
		#continue;
		
		if($scene['t'] != $suggested 
		//&& !($scene['t'] == 'c' && $suggested == 'ccccc') 
		//&& $suggested != 'ccccc'
		&& array_search($suggested, ['ppccc', 'cppcc', 'ccppc', 'cccpp', 'pcccp']) !== false)
		{
			$bogusscenes[] = $scene['row'].' => '.$suggested;
		}
*/				
		// TODO
		//
		// Find (pu pu cp cx cu) as the best two field matches, can start at any position, x means any, likely not p.
		//
		// The sequence will just be the first letters combined for now, but it could be improved by checking the 
		// second letter and the order they follow each other, as above.
		
		$types = [];

		for($k = 0; $k < $cycle; $k++)
		{
			$ts = [];
			
			foreach($mics[$k] as $t => $v)
			{
				$ts[] = $t;
				
				if(count($ts) >= 2) break;
			}
			
			sort($ts); // c < p, lucky

			$types[] = substr(implode($ts), 0, 1);
		}
		
		$suggested = implode('', $types);
		
		if($scene['t'] != $suggested 
		//&& !($scene['t'] == 'c' && $suggested == 'ccccc') 
		//&& $suggested != 'ccccc'
		&& array_search($suggested, ['ppccc', 'cppcc', 'ccppc', 'cccpp', 'pcccp']) !== false)
		{
			$bogusscenes[] = trim($scene['row']).' # '.$suggested;
		}
		
		//
		
		if($scene['e'] > $scene['s'])
		{
			$f = $ovrframes[$scene['s']];

			if((!empty($f['first_pb']) || !empty($f['last_un'])) 
			&& !(isset($f['deint']) && $f['deint']['value'] == '+')
			&& $tfmframes[$scene['s']]['deint'] == '+' 
			&& (!isset($f['Q']) || $f['Q']['value'] >= 5)
			//&& strlen($scene['t']) == 5
			&& !empty($scene['t'])
			)
			{
				$bogussc[$scene['s']] = $scene['s'].' Q 4 # '.$scene['t'].' '.$f['type']['value'];
			}
		}
	}

	//

	$rows = [];

	$typerow = '';

	foreach($bogusframes as $i => $bf)
	{
		$f = $bf['f'];
		
		if($typerow != $f['type']['row'])
		{
			if(!empty($rows)) $rows[] = '';
			$rows[] = $f['type']['row'].(isset($f['deint']['row']) ? PHP_EOL.$f['deint']['row'] : '');
			$rows[] = '';
		
			$typerow = $f['type']['row'];
		}

		$s = ' '.$i.' '.$f['type']['value'];
	
		if(isset($f['deint'])) $s .= ' '.$f['deint']['value'];
		if(isset($f['MI'])) $s .= ' '.$f['MI']['value'];
		if(!empty($bf['note'])) $s .= ' ('.$bf['note'].')';
	
		$rows[] = $s;
	}

	// p/h then u/l means two skipped fields, or a whole frame
	// only a problem during crossfades, scene changes are okay
	// but sections of crossfades are defined as separate scenes...
	// also acceptable when h/l is part of c frame, if the other field has errors
	
	$tp = '';
	$ip = -1;
	/*
	foreach($ovrframes as $i => $f)
	{
		if(isset($ovrframes[$i]['type']['value']))
		{
			$t = $ovrframes[$i]['type']['value'];
			
			if($i == $ip + 1 && ($tp == 'p' || $tp == 'h') && ($t == 'u' || $t == 'l') && !isset($bogusframes[$i]))
			{
				$bogusframes[$i] = ['f' => $f, 'note' => 'p/h followed by u/l'];
			}
			
			$tp = $t;
			$ip = $i;
		}
	}
	*/
	foreach($ovrscenes as $scene)
	{
		$i = $scene['s'];
		$f = $ovrframes[$i];
		
		if(isset($f['type']['value']))
		{
			$t = $f['type']['value'];
			
			if($i == $ip + 1 && ($tp == 'p' || $tp == 'h') && ($t == 'u' || $t == 'l'))
			{
				$bogusscenes[] = trim($scene['row']).' # '.'p/h followed by u/l';
			}

			$ip = $scene['e'];
			$tp = $ovrframes[$ip]['type']['value'];
		}
	}
	
	
	foreach($ovrscenes as $scene)
	{
		if($scene['e'] - $scene['s'] < 2) continue;
		
		if(strpos($scene['t'], 'p') !== false
		|| strpos($scene['t'], 'b') !== false
		|| strpos($scene['t'], 'u') !== false
		|| strpos($scene['t'], 'n') !== false)
			continue;
		
		$tdec = '';
		$dups = 0;
		
		for($i = $scene['s'], $j = $scene['e']; $i <= $j; $i++)
		{
			$f = $tfmframes[$i];
			
			$tdec .= $f['dup'] == 'n' || $f['dup'] == 'p' ? '-' : '+';
			
			if(($f['dup'] == 'n' || $f['dup'] == 'p') && !(isset($ovrframes[$i]['rate']) && $ovrframes[$i]['rate'] == 'f'))
			{
				$dups++;
			}
		}

		if($dups > 0)
		{
			$dupratio = $dups / ($scene['e'] - $scene['s']);
			
			if($dupratio > 0.2 && $dupratio < 0.8) 
			{
				$bogusscenes[] = trim($scene['row']).' # dup '.sprintf("%.1f", $dupratio).' @ '.$tdec;
			}
		}
	}

	file_put_contents("$title-bogusframes.txt", implode(PHP_EOL, $rows));
	file_put_contents("$title-bogusscenes.txt", implode(PHP_EOL, $bogusscenes));
	file_put_contents("$title-bogussc.txt", implode(PHP_EOL, $bogussc));
}

function sanitycheck2()
{
	global $title;
	global $tfmframes;
	global $tdecframes;
	global $ovrframes;
	global $ovrscenes;
	
	$bogusdups = [];
	
	$tdecframes = [];
	
	if(file_exists("$title-tdec-debug.txt"))
	foreach(explode("\n", file_get_contents("$title-tdec-debug.txt")) as $row)
	{
		$row = trim($row);
		
		if(!preg_match('/TDecimate: +inframe = ([0-9]+) +useframe = ([0-9]+)/i', $row, $m)) continue;
		
		$tdecframes[(int)$m[2]] = (int)$m[1];
	}

	//print_r($tdecframes);
	//exit;
	
	// check if two frames were dropped during a scene in a sequence of 5 frames
	// or none for regular sequences
	
	$zerodrops = [];

	foreach($ovrscenes as $index => $scene)
	{
		for($i = $scene['s'], $j = 0, $skipped = []; $i <= $scene['e']; $i++)
		{
			$tlen = strlen($scene['t']);
			
			$t = $tlen > 0 ? $scene['t'][($i - $scene['s']) % $tlen] : '?';
			
			if(!isset($tdecframes[$i]))
			{
				$skipped[] = $i.' '.$t;
			}
			
			if(++$j == 5 || $i == $scene['e'])
			{
				$pos = $i - ($j - 1);
				
				if(count($skipped) > 1)
				{
					$bogusdups[] = ['scene' => $scene, 'pos' => $pos, 'skipped' => $skipped];
				}
				else if($j == 5 && count($skipped) == 0 && strlen($scene['t']) == 5 
				&& (!isset($ovrframes[$i]['rate']) || $ovrframes[$i]['rate'] == 'f')
				&& !($pos == $scene['s'] && substr($scene['t'], 0, 2) == 'pp'))
				{
					$keep = 0;
					$deint = 0;
					
					for($k = $pos; $k <= $i; $k++)
					{
						if(isset($ovrframes[$i]['dec']) && $ovrframes[$i]['dec']['value'] == '+')
						{
							$keep++;
						}

						//if(isset($ovrframes[$i]['deint']) && $ovrframes[$i]['deint']['value'] == '+')
						if(isset($tfmframes[$i]['deint']) && $tfmframes[$i]['deint'] == '+')						
						{
							$deint++;
						}
					}
					
					// don't record if the override keeps every frame or all are deinterlaced
					// also don't when it is near the scene border, it might be forced because there is nothing to drop

					if($keep < $j && $deint < $j 
					//&& $pos > $scene['s'] && $i < $scene['e']
					)
					{
						$zerodrops[] = ['scene' => $scene, 'pos' => $pos, 'skipped' => $skipped];
					}
				}

				$j = 0;
				
				$skipped = [];
			}
		}
	}
	
	// check for dropped frames that are not dups
	
	foreach($ovrscenes as $index => $scene)
	{
		$len = strlen($scene['t']);
		
		if($len != 5) continue;

		$skipped = [];
		
		for($i = $scene['s'], $j = 0; $i <= $scene['e']; $i++, $j++)
		{
			if(!isset($tdecframes[$i]))
			{
				$t = [];
				
				$t[] = $scene['t'][($j - 1 + $len) % $len];
				$t[] = $scene['t'][($j           ) % $len];
				$t[] = $scene['t'][($j + 1       ) % $len];
				
				if($t[0] == 'l' && $t[1] == 'h' && $t[2] == 'h') continue;
				
				$tmp = $t[1];

				foreach($t as $ti => $tt)
				{
					if($tt == 'l' || $tt == 'h') $t[$ti] = 'c';
					else if($tt == 'b') $t[$ti] = 'p';
					else if($tt == 'n') $t[$ti] = 'u';
				}
				
				$prev = $t[0];
				$cur = $t[1];
				$next = $t[2];
				
				if($cur == 'c')
				{
					if(!($prev == 'u' && $i > $scene['s'] || $next == 'p' && $i < $scene['e']))
					{
						$skipped[] = $i.' '.$tmp;
					}
				}
				else if($cur == 'p' && $i > $scene['s'])
				{
					if(!(($prev == 'c' || $prev == 'u') && $i > $scene['s']))
					{
						$skipped[] = $i.' '.$tmp;
					}
				}
				else if($cur == 'u' && $i < $scene['e'])
				{
					if(!(($next == 'c' || $next == 'p') && $i < $scene['e']))
					{
						$skipped[] = $i.' '.$tmp;
					}
				}
			}
		}
		
		if(!empty($skipped)) 
		{
			$bogusdups[] = ['scene' => $scene, 'pos' => $scene['s'], 'skipped' => $skipped];
		}
	}
	
	// ccppc/--++- are usually video, find dropped frames in those scenes
	// many are just crossfades
	
	foreach($ovrscenes as $index => $scene)
	{
		if(strlen($scene['t']) != 5) continue;
		
		$t = str_replace('b', 'p', $scene['t']);
		
		if($t != 'ppccc' && $t != 'cppcc' && $t != 'ccppc' && $t != 'cccpp' && $t != 'pcccp')
			continue;
		
		$skipped = [];
		
		for($i = $scene['s'], $j = 0; $i <= $scene['e']; $i++)
		{
			// deinterlaced p that was auto-dropped
			
			if($t[$j] == 'p' 
			&& isset($ovrframes[$i]['deint']['value']) && $ovrframes[$i]['deint']['value'] == '+' 
			&& !(isset($ovrframes[$i]['dec']) && $ovrframes[$i]['dec']['value'] == '-')
			&& !isset($tdecframes[$i]))
			{
				$skipped[] = $i.' '.$t[$j];
			}
			
			if(++$j == 5) $j = 0;
		}

		if(!empty($skipped)) 
		{
			$bogusdups[] = ['scene' => $scene, 'pos' => $scene['s'], 'skipped' => $skipped];
		}
	}
	
	// auto-dropped v, usually because the 5 frame batch has a mixed f scene

	foreach($ovrscenes as $index => $scene)
	{
		$skipped = [];
		
		for($i = $scene['s'], $j = 0; $i <= $scene['e']; $i++)
		{
			$f = $ovrframes[$i];
	
			if(isset($f['rate']) && $f['rate'] == 'v' && !isset($tdecframes[$i]))
			{
				$skipped[] = $i.' (auto-dropped)';
			}
		}

		if(!empty($skipped)) 
		{
			$bogusdups[] = ['scene' => $scene, 'pos' => $scene['s'], 'skipped' => $skipped];
		}
	}
	
	//
	
	foreach($zerodrops as $s)
	{
		//if(count(s['skipped']) > 1)
		{
			$bogusdups[] = $s;
		}
	}

	//

	if(!empty($bogusdups))
	{
		$fp = fopen("$title-bogusscenes.txt", 'a');

		fprintf($fp, "\n\n");

		foreach($bogusdups as $dups)
		{
			fprintf($fp, "%s @ %d\n", $dups['scene']['row'], $dups['pos']);
	
			foreach($dups['skipped'] as $skipped)
			{
				fprintf($fp, "- %s\n", $skipped);
			}
		}

		fclose($fp);
	}
}

function genranges()
{
	global $title;
	
	$s = file_get_contents("$title-timecodes.txt");
	
	$sl = [];
	$sep = '# ranges';
	$frames = [];
	$pef = -1;

	foreach(explode("\n", $s) as $row)
	{
		$row = trim($row);
		
		if($row == $sep) break;
		
		$sl[] = $row;
	
		if(!preg_match('/^([0-9]+),([0-9]+),([0-9\\.]+)/i', $row, $m)) continue;
	
		$sf = (int)$m[1];
		$ef = (int)$m[2];
	
		if($sf > $pef + 1)
		{
			$frames[] = ['sf' => $pef + 1, 'ef' => $sf - 1, 'fps_num' => 30000, 'row' => ''];
		}

		$pef = $ef;
	
		if($m[3] == '29.97') $fps_num = 30000;
		else if($m[3] == '23.976024') $fps_num = 24000;
		else if($m[3] == '17.982018') $fps_num = 18000;
		else die('unknown fps '.$m[3]);
	
		$frames[] = ['sf' => $sf, 'ef' => $ef, 'fps_num' => $fps_num, 'row' => $row];
	}

	$frames[] = ['sf' => $pef + 1, 'ef' => 1000000, 'fps_num' => 30000, 'row' => '']; // TODO: last frame number?

	//

	$fp = fopen("$title-timecodes.txt", 'w');
	
	foreach($sl as $s) fprintf($fp, "%s\n", $s);
	fprintf($fp, "%s\n\n", $sep);

	$tfc = 0;

	foreach($frames as $f)
	{
		$fc = ($f['ef'] - $f['sf'] + 1) * 30000 / $f['fps_num'];
		
		fprintf($fp, "# %d,%d,%.6f # %s\n", (int)$tfc, (int)($tfc + $fc + 0.5), $f['fps_num'] / 1001, $f['row']);

		$tfc += $fc;
	}

	fclose($fp);
}

//

init();

if(!file_exists("$title-tfm-ovr.txt")) file_put_contents("$title-tfm-ovr.txt", '');
if(!file_exists("$title-tdec-ovr.txt")) file_put_contents("$title-tdec-ovr.txt", '');
//if(!file_exists("$title-tdeint-ovr.txt")) file_put_contents("$title-tdeint-ovr.txt", '');

// source

$avs_source = <<<EOT
title = ReplaceStr(ScriptFile(), ".avs", "")
MPEG2Source(title + ".d2v",cpu=4)
EOT;

if(!file_exists("$title.avs")) file_put_contents("$title.avs", $avs_source);

$avs = <<<EOT
Import("$title.avs")
#showframenumber(x=5,y=475).separatefields.lanczosresize(720,480)
deint2 = yadifmod2(order=0)
deint3 = yadifmod2(order=1)
f0 = nnedi3(field=0)
f1 = nnedi3(field=1)
EOT;

// virtualdub

$avs_virtualdub = <<<EOT
$avs
TFM(clip2=deint2,clip3=deint3,nnedi3f0=f0,nnedi3f1=f1,mode=0,slow=2,cthresh=$cthresh,MI=$MI,PP=$PP,chroma=true,display=true,ovr="$title-tfm-ovr.txt")
#TDecimate(mode=0,hybrid=1,denoise=true,ovr="$title-tdec-ovr.txt")
EOT;

if(!file_exists("$title-virtualdub.avs")) file_put_contents("$title-virtualdub.avs", $avs_virtualdub);

$avs_1pass = <<<EOT
$avs
TFM(clip2=deint2,clip3=deint3,nnedi3f0=f0,nnedi3f1=f1,mode=0,slow=2,cthresh=$cthresh,MI=$MI,PP=$PP,chroma=true,micout=2,output="$title-tfm.txt",ovr="$title-tfm-ovr.txt")
TDecimate(mode=3,hybrid=2,denoise=true,vfrDec=0,mkvOut="$title-timecodes.txt",output="$title-tdec.txt",debugOut="$title-tdec-debug.txt",ovr="$title-tdec-ovr.txt")
EOT;

$avs_2pass1st = <<<EOT
$avs
TFM(clip2=deint2,clip3=deint3,nnedi3f0=f0,nnedi3f1=f1,mode=0,slow=2,cthresh=$cthresh,MI=$MI,PP=$PP,chroma=true,micout=2,output="$title-tfm.txt",ovr="$title-tfm-ovr.txt")
TDecimate(mode=4,denoise=true,output="$title-tdec.txt")
crop(344,224,-344,-224)
EOT;

$avs_2pass2nd = <<<EOT
$avs
TFM(clip2=deint2,clip3=deint3,nnedi3f0=f0,nnedi3f1=f1,mode=0,slow=2,cthresh=$cthresh,MI=$MI,PP=$PP,chroma=true,input="$title-tfm.txt",ovr="$title-tfm-ovr.txt")
TDecimate(mode=5,hybrid=2,denoise=true,vfrDec=0,input="$title-tdec.txt",tfmIn="$title-tfm.txt",mkvOut="$title-timecodes.txt",debugOut="$title-tdec-debug.txt",ovr="$title-tdec-ovr.txt")
EOT;

$avs_field0 = <<<EOT
Import("$title.avs")
ConvertToYV24
SeparateRows(2)
SelectOdd
EOT;

$avs_field1 = <<<EOT
Import("$title.avs")
ConvertToYV24
SeparateRows(2)
SelectEven
EOT;

function ffmpeg($cmd, $avs)
{
	global $title;
	
	$src = tempnam('.', $title);
	file_put_contents($src, $avs);
	register_shutdown_function(function() use($src) { unlink($src); });	

	$cmd = '"e:\\tmp\\media\\util\\ffmpeg_x86\\bin\\ffmpeg.exe" -hide_banner -f avisynth -i "'.$src.'" '.$cmd;

	echo $cmd.PHP_EOL;
	
	$ret = 0;
	passthru($cmd, $ret);
	if(!empty($ret)) die($ret);
}

if(isset($argv[2]) && strpos($argv[2], 'fields') !== false)
{
	$trim = [];
	$has_field = [false, false, false];
	$prev_field = 2;
	$inframe_s = 0;
	$inframe_e = -1;
	$useframe_s = 0;
	$useframe_e = -1;
	
	foreach(explode("\n", file_get_contents("$title-tdec-debug.txt")) as $row)
	{
		$row = trim($row);
		
		if(!preg_match('/TDecimate: +inframe = ([0-9]+) +useframe = ([0-9]+)/i', $row, $m)) continue;
		
		$inframe = (int)$m[1];
		$useframe = (int)$m[2];

		$field = 2;
		
		if(isset($ovrframes[$useframe]))
		{
			$f = $ovrframes[$useframe];

			$hl_scene = false;
			
			if(isset($f['type']))
			{
				$type = $f['type'];
				
				if(isset($type['value']) && ($type['value'] == 'h' || $type['value'] == 'l') && isset($type['scene']))
				{
					$scene = $type['scene'];
					
					if($scene['e'] > $scene['s'] && strlen($scene['t']) == 1)
					{
						$hl_scene = true;
					}
				}	
			}
			
			if($hl_scene && isset($f['Q']['value']) && ($f['Q']['value'] == 4 || $f['Q']['value'] == 7))
			{
				$field = $f['type']['value'] == 'h' ? 1 : 0;
			}
		}
		
		$has_field[$field] = true;
		
		if($field != $prev_field || $prev_field != 2 && $useframe > $useframe_e + 1)
		{
			if($useframe_e >= 0)
			{
				if($prev_field != 2)
				{
					$trim[] = ['s' => $useframe_s, 'e' => $useframe_e, 'f' => $prev_field];
				}
				else
				{
					$trim[] = ['s' => $inframe_s, 'e' => $inframe_e, 'f' => $prev_field];
				}
			}
			
			$inframe_s = $inframe;
			$useframe_s = $useframe;
		}
		
		$prev_field = $field;
		
		$inframe_e = $inframe;
		$useframe_e = $useframe;
	}
	
	if($prev_field != 2)
	{
		$trim[] = ['s' => $useframe_s, 'e' => $useframe_e, 'f' => $prev_field];
	}
	else
	{
		$trim[] = ['s' => $inframe_s, 'e' => $inframe_e, 'f' => $prev_field];
	}
	
	$fp = fopen($title.'-topaz-png.avs', 'w');
	
	if($has_field[2])
	{
		fprintf($fp, "i2 = ImageSource(file=\"%s-huffyuv_1.50x_1080x720_ahq-11_png\\%%06d.png\", start=0, end=%d)\n", $title, $inframe);
		
		if($has_field[0] || $has_field[1])
		{
			// TODO: if the majority is 480p, resize i0/i1 to 1080x720 instead (very unlikely in S03)
			
			fprintf($fp, "i2 = i2.Spline64Resize(1080, 540)\n");
		}
	}

	if($has_field[0])
	{
		fprintf($fp, "i0 = ImageSource(file=\"%s-f0-huffyuv_2.00x_1080x540_aaa-9_png\\%%06d.png\", start=0, end=%d)\n", $title, $useframe);
	}

	if($has_field[1])
	{
		fprintf($fp, "i1 = ImageSource(file=\"%s-f1-huffyuv_2.00x_1080x540_aaa-9_png\\%%06d.png\", start=0, end=%d)\n", $title, $useframe);
	}
	
	$cl = [];
	$total = 0;
	
	foreach($trim as $i => $t)
	{
		$c = sprintf("c%d", $i);
		fprintf($fp, "%s = Trim(i%d, %d, %d)\n", $c, $t['f'], $t['s'], $t['e']);
		$cl[] = $c;
		$total += $t['e'] - $t['s'] + 1;
	}

	// experiment to test if avisynth reads clips organized into a tree faster

	$next = count($cl);
	
	$batchsize = 10;

	if(0)
	while(count($cl) > 1)
	{
		$cl2 = [];
	
		for($i = 0; $i < count($cl); $i += $batchsize)
		{
			$c = sprintf("c%d", $next++);
			fprintf($fp, "%s = %s\n", $c, implode('+', array_slice($cl, $i, $batchsize)));
			$cl2[] = $c;
		}
	
		$cl = $cl2;
	}
	
	//
	
	fputs($fp, implode('+', $cl)."\n");

	fclose($fp);
	
	if($total != $inframe + 1) die('check frame count '.$total.' != '.($inframe + 1));
	
	$cmd = '-map 0:v -y -c:v ffvhuff -aspect 480:240'; 
	
	# upscale with topaz ai, aa, 2.25x, 1080x540, anything >=2.5x and the picture falls apart, small features like stripes and holes connect in a wrong way
	
	if($has_field[0])
	{
		$dst = $title.'-f0-huffyuv.avi';
	
		if($force || !file_exists($dst))
		{
			ffmpeg($cmd.' "'.$dst.'"', $avs_field0);
		}
	}
	
	if($has_field[1])
	{
		$dst = $title.'-f1-huffyuv.avi';
	
		if($force || !file_exists($dst))
		{
			ffmpeg($cmd.' "'.$dst.'"', $avs_field1);
		}
	}
		
	exit;
}

$out = strpos($argv[2], 'null') === false ? '-c:v ffvhuff -aspect 720:480 "'.$title.'-huffyuv.avi"' : '-f null -';

if(isset($argv[2]) && strpos($argv[2], '1pass') !== false)
{
	if($force || !file_exists("$title-tfm.txt") || !file_exists("$title-tdec.txt"))
	{
		ffmpeg('-map 0:v '.($force ? '-y ' : '').$out, $avs_1pass);
	}

	sanitycheck1();
}
else // if(isset($argv[2]) && strpos($argv[2], '2pass') !== false)
{
	if($force || !file_exists("$title-tfm.txt") || !file_exists("$title-tdec.txt"))
	{
		ffmpeg('-c copy -f null -', $avs_2pass1st);
	}

	sanitycheck1();

	if($force || file_exists("$title-tfm.txt") && file_exists("$title-tdec.txt") && (!file_exists("$title-timecodes.txt") || !file_exists("$title-huffyuv.avi")))
	{
		ffmpeg('-map 0:v '.($force ? '-y ' : '').$out, $avs_2pass2nd);
	}
}

sanitycheck2();

genranges();

?>
