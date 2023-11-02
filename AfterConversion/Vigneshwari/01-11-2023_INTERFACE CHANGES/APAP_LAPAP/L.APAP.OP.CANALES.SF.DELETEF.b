* @ValidationCode : MjotMzYwMjU5NjY5OkNwMTI1MjoxNjk4ODMyNzk4NTkxOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 01 Nov 2023 15:29:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.OP.CANALES.SF.DELETEF
    
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - Include to Insert and T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - PATH IS MODIFIED
* 01/11/2023	     VIGNESHWARI           ADDED COMMENT FOR INTERFACE CHANGES- Interface Change by Santiago
*------------------------------------------------------------------------
	$INSERT I_COMMON   	;*Interface Change by Santiago-NEW LINES ADDED -START
   $INSERT I_EQUATE
   $INSERT I_GTS.COMMON		;*Interface Change by Santiago-END
    $INSERT I_F.DATES
*  EXECUTE 'COPY FROM ../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF TRANSF.OP.CANALES.SF.TXT TO ../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF/TEMP OVERWRITING DELETING' ;*R22 Manual Conversion PATH IS MODIFIED	;*Interface Change by Santiago


   
;*   EXECUTE 'SH -c cp ../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF/TRANSF.OP.CANALES.SF.TXT  ;*../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF/TEMP OVERWRITING DELETING'		;*Interface Change by Santiago-COMMENTED
   
   
    SOURCE.IM.PATH = "../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF"		;*Interface Change by Santiago-NEW LINES ADDED -START
    FILE.NAME = "TRANSF.OP.CANALES.SF.txt"
    FINAL.DIR.NAME = "../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF/TEMP"
 
	FILE.NAME.2 = "DMMD.TRANSF.OP.CANALES.SF-TRANSF.OP.CANALES.SF-ERROR.txt" 
 
	SHELL.CMD ='SH -c '
    EXEC.COM="cat "
     
    EXE.CAT = "cat ":SOURCE.IM.PATH:"/":FILE.NAME:" >> ":FINAL.DIR.NAME:"/":FILE.NAME
	EXE.CP="cp ":SOURCE.IM.PATH:"/":FILE.NAME:" ":FINAL.DIR.NAME:"/":FILE.NAME	
    EXE.RM="rm ":SOURCE.IM.PATH:"/":FILE.NAME
    
    DAEMON.CMD = SHELL.CMD:EXE.CAT
    DAEMON.CP.CMD = SHELL.CMD:EXE.CP
	DAEMON.REM.CMD = SHELL.CMD:EXE.RM	

    EXECUTE DAEMON.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.CAT.VALUE
    EXECUTE DAEMON.CP.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.CP.VALUE
    EXECUTE DAEMON.REM.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.REM.VALUE
	
	SHELL.CMD ='SH -c '
	EXE.RM.2="rm ":SOURCE.IM.PATH:"/":FILE.NAME.2
	DAEMON.REM.CMD.2 = SHELL.CMD:EXE.RM.2	
 
    EXECUTE DAEMON.REM.CMD.2 RETURNING RETURN.VALUE CAPTURING CAPTURE.REM.VALUE			;*Interface Change by Santiago -END
	
	
RETURN
END
