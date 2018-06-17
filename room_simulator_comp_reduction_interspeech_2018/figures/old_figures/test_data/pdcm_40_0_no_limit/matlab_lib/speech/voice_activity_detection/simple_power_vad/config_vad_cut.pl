$szMFuncName   = "VADCut";
$iPartSize     = 1000;
$szInExt       = "sph";
$szOutExt      = "sph";
$szParmFile    = "";
$szParmVal     = "";

$bPBS = 0;

$szCurDir = `./pwd.pl`;
chomp ($szCurDir);

$szInTopDir    = "/net/katsura/work/chanwook/NOISY_DB_SPH/WSJ_ALL_Train";
$szInCtlFile   = "/net/katsura/work/chanwook/NOISY_DB_SPH/WSJ_ALL_Train/CTL_si84";
$szOutCtlFile  = $szInCtlFile;

##### The above is copy and paste. but the below is not copy and paste...
$szOutTopDir   = "/net/katsura/work/chanwook/NOISY_DB_SPH/WSJ_OFFLINE_VAD/WSJ_ALL_Train";
@aszPath = ("$szCurDir");

