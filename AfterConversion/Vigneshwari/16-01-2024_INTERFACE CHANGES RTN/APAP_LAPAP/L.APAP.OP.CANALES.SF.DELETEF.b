* @ValidationCode : MjoxNzQ3NzAwMzQzOkNwMTI1MjoxNzA1NTc3NDMyNzg0OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Jan 2024 17:00:32
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
*09-01-2024	     VIGNESHWARI           ADDED COMMENT FOR INTERFACE CHANGES          SQA-12331 - By Santiago
*18-01-2024	     VIGNESHWARI           ADDED COMMENT FOR INTERFACE CHANGES          SQA-12331 - By Santiago
*------------------------------------------------------------------------
    $INSERT I_COMMON   	;*Interface Change by Santiago-NEW LINES ADDED -START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON		;*Interface Change by Santiago-END
    $INSERT I_F.DATES
*  EXECUTE 'COPY FROM ../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF TRANSF.OP.CANALES.SF.TXT TO ;*    ../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF/TEMP OVERWRITING DELETING' ;*R22 Manual Conversion PATH IS MODIFIED	;*Interface Change by Santiago

   
;*   EXECUTE 'SH -c cp ../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF/TRANSF.OP.CANALES.SF.TXT  ;*../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF/TEMP OVERWRITING DELETING'		;*Interface Change by Santiago-COMMENTED
   
   
    SOURCE.IM.PATH = "../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF"		;*Interface Change by Santiago-NEW LINES ADDED -START
;*FILE.NAME = "TRANSF.OP.CANALES.SF.txt"	;*Fix SQA-12331- By Santiago-commented
    FILE.NAME.M = "TRANSF.OP.CANALES.SF.TXT"	;*Fix SQA-12331 - By Santiago-new lines is added
    FINAL.DIR.NAME = "../interface/FLAT.INTERFACE/TRANSF.OP.CANALES.SF/TEMP"
 
    FILE.NAME.2 = "DMMD.TRANSF.OP.CANALES.SF-TRANSF.OP.CANALES.SF-ERROR.txt"
 ;*Fix SQA-12331- By Santiago-commented-start
;*SHELL.CMD ='SH -c '
;*EXEC.COM="cat "
     
;*EXE.CAT = "cat ":SOURCE.IM.PATH:"/":FILE.NAME:" >> ":FINAL.DIR.NAME:"/":FILE.NAME
;*EXE.CP="cp ":SOURCE.IM.PATH:"/":FILE.NAME:" ":FINAL.DIR.NAME:"/":FILE.NAME
;*EXE.RM="rm ":SOURCE.IM.PATH:"/":FILE.NAME
    
;*DAEMON.CMD = SHELL.CMD:EXE.CAT
;*DAEMON.CP.CMD = SHELL.CMD:EXE.CP
;*DAEMON.REM.CMD = SHELL.CMD:EXE.RM

;*EXECUTE DAEMON.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.CAT.VALUE
;*EXECUTE DAEMON.CP.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.CP.VALUE
;*EXECUTE DAEMON.REM.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.REM.VALUE
 ;*Fix SQA-12331- By Santiago-commented-end   
    SHELL.CMD ='SH -c '
    EXE.RM.2="rm ":SOURCE.IM.PATH:"/":FILE.NAME.2
    DAEMON.REM.CMD.2 = SHELL.CMD:EXE.RM.2
 
    EXECUTE DAEMON.REM.CMD.2 RETURNING RETURN.VALUE CAPTURING CAPTURE.REM.VALUE
    
    EXE.CAT.M = "cat ":SOURCE.IM.PATH:"/":FILE.NAME.M:" >> ":FINAL.DIR.NAME:"/":FILE.NAME.M	;*Fix SQA-12331- By Santiago-new line
    EXE.CP.M="cp ":SOURCE.IM.PATH:"/":FILE.NAME.M:" ":FINAL.DIR.NAME:"/":FILE.NAME.M	;*Fix SQA-12331- By Santiago-new line
    EXE.RM.M="rm ":SOURCE.IM.PATH:"/":FILE.NAME.M
    
    DAEMON.CMD.M = SHELL.CMD:EXE.CAT.M	;*Fix SQA-12331- By Santiago-new line
    DAEMON.CP.CMD.M = SHELL.CMD:EXE.CP.M	;*Fix SQA-12331- By Santiago-new line
    DAEMON.REM.CMD.M = SHELL.CMD:EXE.RM.M

    EXECUTE DAEMON.CMD.M RETURNING RETURN.VALUE CAPTURING CAPTURE.CAT.VALUE	;*Fix SQA-12331- By Santiago-new line
    EXECUTE DAEMON.CP.CMD.M RETURNING RETURN.VALUE CAPTURING CAPTURE.CP.VALUE	;*Fix SQA-12331- By Santiago-new line
    EXECUTE DAEMON.REM.CMD.M RETURNING RETURN.VALUE CAPTURING CAPTURE.REM.VALUE
	
;*Fix SQA-12331 - By Santiago-end
RETURN
END
