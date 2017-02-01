<?php
/* 					 Wordcloud PHP API 
 * 				Author : Thibaut LOMBARD  			   								
 ************************************************************************************
 *				  Desc : The wordcloud API			   
 *				 is a programming interface 			    
 *				dedicated to throw the infos 			   
 * 				 related to a webpage, or a  			    
 * 			        remote text file in order to  			  
 *				 analyse the data with some   			   
 *				   Visualisation features   			  
 ************************************************************************************/						
/*---------------------------Error Displaying & Class loading-----------------------*/
 error_reporting(0);
 ini_set("display_errors", 0);
@require_once('worcloud.class.php');
/*----------------------------------Protection Functions----------------------------*/
		//protecting against SQL Injections
		function clean($variable) {
				$variable2 = utf8_decode($variable);
				if (get_magic_quotes_gpc())
					{
			$variable2 = stripslashes($variable2);
		}
		$variable2 = mysql_real_escape_string($variable2);
		$variable2 = utf8_encode($variable2);
		return $variable2;
		}

		//protecting against XSS
		function secu_txt($text) {
    			return htmlentities(strip_tags($text), ENT_QUOTES, 'UTF-8');
		}
/*--------------------------------End of Protection Functions-------------------------*/
/*	Note : Some variables has been disabled (commented) for security purpose      */
/*----------------------------------Variable assignements-----------------------------*/
	
	//Create arrays to manage the input validations
	$Rscript = new Rscript();
	$errmsg_arr = array();
	$typearr = array("typei=url","typei=text","typei=file");
	$typelng = array("french","english","arabic");
	$mode = array("poor","fullconf");
	$getmode = $_GET["mode"];
	//variables 1 by 1	
	//path p=
	$p0 = $_GET["p"];
	$p = "-p=".$p0;
	//type of input
	//$typei = "-typei=".$_GET["typei"];
	//Working directory
	//$wd = "-wd=".$_GET["wd"];
	//wordcloud png filename
	//$pngfw = "-pngfw=".$_GET["pngfw"];
	//langage
	$lng0=$_GET["lng"];
	$lng = "-lng=".$_GET["lng"];
	//minimal word frequency (integer)
	$minfreq0 = $_GET["minfreq"];
	$minfreq = "-minfreq=".$_GET["minfreq"];
	//maximum word frequency (integer)
	$maxword0 = $_GET["maxword"];
	$maxword = "-maxword=".$_GET["maxword"];
	//minimum result of the frequency table
	$numft0 = $_GET["numft"];
	$numft = "-numft=".$_GET["numft"];
	//frequency table output filename	
	//$numfto = "numfto=".$_GET["numfto"];
	//barchart output filename
	//$bcof = "bcof=".$_GET["bcof"];
	//barchart title
	$bartitle = "-bartitle=".secu_txt($_GET["bartitle"]);
	//label of y axis
	$ylabel = "-ylabel=".secu_txt($GET_["ylabel"]);
	//filename for the correlation output file
	//$correlfilename = "-correlfilename=".$_GET["correlfilename"];
	//correlation term
	$correlterm = "-correlterm=\"".secu_txt($_GET["correlterm"])."\"";
	//correlation rate
	$correlrate0 = $_GET["correlrate"];
	$correlrate = "-correlrate=".$_GET["correlrate"];
	//minimal value of the term frequency to extract
	$freqterme0 = $_GET["freqterme"];
	$freqterme = "-freqterme=".$_GET["freqterme"];
	//term frequency output csv file
	//$termfreqtxt ="-termfreqtxt=".$_GET["termfreqtxt"];
/*---------------------------------End of variable assignements-----------------------*/
/*--------------------------All the interesting functions-----------------------------*/
	
	//checking p to find the type of data (remote textfile, URL, text)
	function checkp($vartypei) {
			if (preg_match("%^((https?://)|(www\.))([a-z0-9-].?)+(:[0-9]+)?(/.*)?$%i", $vartypei)) {
				$typei = "--typei=url";
			} elseif (strpbrk($vartypei, "\\/?%*:|\"<>")) {
				$typei = "--typei=file";
			} else {
			$typei = "--typei=text";
			}return $typei;
		    }	//end of function checktypei	

			$pcheck = checkp($p0);
			/*if (in_array($pcheck, $typearr)) {
			     			echo $pcheck;
			  				} */
	function delete_first_line($filename) {
			  $file = file($filename);
			  $output = $file[0];
			  unset($file[0]);
			  file_put_contents($filename, $file);
			  return $output;
			}	
		//create callback for return
		if(isset($_GET['callback']))    {
		$callback = $_GET['callback'];    
			}  
	//read  csv file function
	function csv_in_array($url,$delm=";",$encl="\"",$head=true) {
   
			    $csvxrow = file($url);   // ---- csv rows to array ----
			   
			    $csvxrow[0] = chop($csvxrow[0]);
			    $csvxrow[0] = str_replace($encl,'',$csvxrow[0]);
			    $keydata = explode($delm,$csvxrow[0]);
			    $keynumb = count($keydata);
			   
			    if ($head === true) {
			    $anzdata = count($csvxrow);
			    $z=0;
			    for($x=1; $x<$anzdata; $x++) {
				$csvxrow[$x] = chop($csvxrow[$x]);
				$csvxrow[$x] = str_replace($encl,'',$csvxrow[$x]);
				$csv_data[$x] = explode($delm,$csvxrow[$x]);
				$i=0;
				foreach($keydata as $key) {
				    $out[$z][$key] = $csv_data[$x][$i];
				    $i++;
				    }   
				$z++;
				}
			    }
			    else {
				$i=0;
				foreach($csvxrow as $item) {
				    $item = chop($item);
				    $item = str_replace($encl,'',$item);
				    $csv_data = explode($delm,$item);
				    for ($y=0; $y<$keynumb; $y++) {
				       $out[$i][$y] = $csv_data[$y];
				    }
				$i++;
				}
			    }

			return $out;
			}
/*---------------------------End of all the interesting functions---------------------*/
/*----------------------------------Errors Management---------------------------------*/
		//Set Error validation flag to off
		$errflag = false;

		//check if numeric variables values are valid
		//$minfreq0 $maxword0 $numft0 $correlrate0 $freqterme0
		if (isset($minfreq0) && !is_numeric($minfreq0)) {
     			$errmsg_arr[] = 'Error , variable minfreq must be numeric.';
			$errflag = true;
  				} 
		if (isset($maxword0) && !is_numeric($maxword0)) {
     			$errmsg_arr[] = 'Error , variable maxword must be numeric.';
			$errflag = true;
  				} 
		if (isset($numft0) && !is_numeric($numft0)) {
     			$errmsg_arr[] = 'Error , variable minfreq must be numeric.';
			$errflag = true;
  				} 
		if (isset($correlrate0) && !is_numeric($correlrate0)) {
     			$errmsg_arr[] = 'Error , variable correlrate must be numeric.';
			$errflag = true;
  				} 
		if (isset($freqterme0) && !is_numeric($freqterme0)) {
     			$errmsg_arr[] = 'Error , variable minfreq must be numeric.';
			$errflag = true;
  				} 
		//end of check the numeric values
		//start of check lng
		if (!in_array($lng0, $typelng)) {
			$errmsg_arr[] = 'Error , variable lng must be french,english or arabic.';
			$errflag = true;
				} 
		//end of check lng var
		//check if the mode is correct
		if (!in_array($getmode, $mode)) {
			$errmsg_arr[] = 'Error , invalid mode , available modes are poor, fullconf.';
			$errflag = true;
				} 
				//loop to throw whole errors
				if(isset($errmsg_arr) && is_array($errmsg_arr) && count($errmsg_arr >0 )) {
					foreach($errmsg_arr as $msg) {
						echo '<li>',$msg,'</li>'; 
								}//end of foreach errmsgarray
					} //fin du ifisset errmsgarray
				if($errflag){
				echo 'Unable to  execute the source code.';
				} else {
			//configure query arguments
			switch($getmode)
				{
				case 'poor';
				//debug
				//./NU.r -p=http://www.thealmightyguru.com/Music/Lyrics/Beauty%20and%20the%20Beast/Bonjour.txt --typei=url -correlfilename=correlterms.csv -correlterm="bonjour" -correlrate=0.1
				//echo "Commande line  : <br>
					//./NU.r ".$poor0."<br>";
				// debug
				//echo "./NU.r ".$poor0."\n"; 

				$poor0 = $p." --typei=url ".$lng." -correfilename=correlterms.csv ".$correlterm." ".$correlrate;
				$poor=$Rscript->query($poor0);
				$poor;
				header('Content-Type: application/json');
				//$arrjson = array('poor'=> $poor);
				$csvfile ="tableoutput.csv";
				$csvfile2 ="correlterms.csv";
				$csvfile3 ="termsfrequency.csv";
				//removedline
				delete_first_line($csvfile);
				delete_first_line($csvfile2);
				delete_first_line($csvfile3);
				echo $callback."({\"tableoutput\":\"";
				$csvdatatableoutput = csv_in_array( $csvfile, ";", "\"", False );
				foreach ($csvdatatableoutput as $key => $data) {
				//loop to throw the data
				$word = $data[0];
				$word2 =  $data[2];
				echo $word."(".$word2.");";
				}

				$csvdatacorrelterms =  csv_in_array( $csvfile2, ";", "\"", False );
				echo "\",\"correlation\":\"";
				foreach ($csvdatacorrelterms as $key => $value) {
				//loop to throw the data
				$word1 = $value[0];
				$wordrate =  $value[1];
				echo $word1."(".$wordrate.");";
				}

				$csvfreqtable = csv_in_array( $csvfile3, ";", "\"", False );
				echo "\",\"freqtable\":\"";
				foreach ($csvfreqtable as $key => $value) {
				//loop to throw the data
				$wordnum = $value[0];
				$wordfreq1 =  $value[1];
				echo $wordfreq1.";";
				}
				$barcharturl = "barchart.png";
				$wordcloudurl = "wordcloud.png";
				echo "\",\"barchart\":\"http://".$_SERVER['HTTP_HOST']."/wordcloud/".$barcharturl."\",\"wordcloud\":\"http://".$_SERVER['HTTP_HOST']."/wordcloud/".$wordcloudurl."\"})";
				//header('Content-Type: application/json; charset=utf-8');
				header('Content-type: application/json');
				break;
				//FULL MODE
				//case 'fullconf';
				//WIP
				//break;
				exit();
				}

					
			}

?>
