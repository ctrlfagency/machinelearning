<?php
/*
 * @file Rscript.php
 * Thibaut LOMBARD
 */
class Rscript
{
    var $cmd;

    function Rscript()
    {
        $this->set_Rscript_cmd();
        return;
    }
    
    function set_Rscript_cmd()
    {
        if (file_exists('/usr/local/bin/Rscript'))
        {
            $this->cmd = '/usr/local/bin/Rscript';
        }
        elseif (file_exists('/usr/bin/Rscript'))
        {
            $this->cmd = '/usr/bin/Rscript';
        }
        elseif (file_exists('/bin/Rscript'))
        {
            $this->cmd = '/bin/Rscript';
        }
        else
        {
            die("<h1>Erreur:</h1>\n<p>Rscript est introuvable.</p>");
        }
    }
    
    function query($inputdata) 
    {
              return nl2br(shell_exec(escapeshellcmd($this->cmd ." NU.r ". $inputdata)));
    }
}
?>
