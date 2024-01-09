* @ValidationCode : MjoxODQwMTc3NTgzOkNwMTI1MjoxNzA0ODAxMjY3ODQwOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 17:24:27
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

SUBROUTINE REDO.APAP.PRESTAC.LAB.DELETEF    
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - $INCLUDE TO $INSERT
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - PATH IS MODIFIED
*09-01-2024	   VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES          SQA-11970 � By Santiago
*------------------------------------------------------------------------------------------------------
;*Fix SQA-11970 � By Santiago-new lines added-start 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
;*Fix SQA-11970 � By Santiago-end    
    $INSERT I_F.DATES           ;** R22 Auto conversion - $INCLUDE TO $INSERT

*   EXECUTE 'COPY FROM ../interface/FLAT.INTERFACE/TRANSPRESTALAB PAGO.PRESTACIONES.LABORALES.TXT TO ../interface/FLAT.INTERFACE/TRANSPRESTALAB/TEMP OVERWRITING DELETING' ;*R22 Manual Conversion PATH IS MODIFIED
*   EXECUTE 'SH -c cp  ../interface/FLAT.INTERFACE/TRANSPRESTALAB/PAGO.PRESTACIONES.LABORALES.TXT ../interface/FLAT.INTERFACE/TRANSPRESTALAB/TEMP OVERWRITING DELETING'	;*Fix SQA-11970 � By Santiago-commented
;*Fix SQA-11970 � By Santiago-new lines is added- start
	SOURCE.IM.PATH = "../interface/FLAT.INTERFACE/TRANSPRESTALAB"
    FILE.NAME = "PAGO.PRESTACIONES.LABORALES.TXT"
    FINAL.DIR.NAME = "../interface/FLAT.INTERFACE/TRANSPRESTALAB/TEMP/"
 
	FILE.NAME.2 = "DMMD.TRANSF.PRESTAC.LAB-PAGO.PRESTACIONES.LABORALES-ERROR.txt" 

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
 
    EXECUTE DAEMON.REM.CMD.2 RETURNING RETURN.VALUE CAPTURING CAPTURE.REM.VALUE
;*Fix SQA-11970 � By Santiago-end    
RETURN

END
