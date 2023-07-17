* @ValidationCode : MjoxODY3Njk1OTgzOlVURi04OjE2ODQyMjI4MjgzODI6SVRTUzotMTotMTo3MzU6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:28
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 735
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.THIRD.RES.RECOVERY.POST
*-----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine reads APAP.REPORT.TEMP and generates a flat file.
*
* Developed By          : Thilak Kumar K
*
* Development Reference :
*
* Attached To           : BATCH>BNK/REDO.B.THIRD.RES.RECOVERY
*
* Attached As           : Batch Routine
*-----------------------------------------------------------------------------------------------------------------
*------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
* Argument#2 : NA
* Argument#3 : NA
*-----------------------------------------------------------------------------------------------------------------
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
*   Date       Author              Modification Description
* 29/10/2014  Ashokkumar.V.P        PACS00353049 - New mapping changes
** 24-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 24-04-2023 Skanda R22 Manual Conversion - Call method format changed
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $INSERT I_REDO.B.THIRD.RES.RECOVERY.COMMON ;* R22 Auto conversion
    $USING APAP.REDOCHNLS
*
    SLEEP 60
    GOSUB INITIALIZE
    GOSUB PROCESS
*
RETURN
*-----------------------------------------------------------------------------------------------------------------
*
INITIALIZE:
*----------
*Initialize the variables
*Open the neccessary files
*-----------------------------------------------------------------------------------------------------------------
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ""
*
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    Y.TEMP.RECORD='';Y.LINE='';Y.GROUP='';Y.AMOUNT='';Y.REC='';Y.GROUP1='';Y.GROUP2='';Y.GROUP3=''
    Y.NAME1='';Y.NAME2='';Y.NAME3='';Y.CONSUMO='';Y.HIPOTECARIO='';Y.COMERCIAL='';Y.CON.TOTAL='';Y.HIP.TOTAL='';Y.COM.TOTAL=''
*
    Y.PARAM.ID = 'REDO.RES.REC'
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
*
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        FN.CHK.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
        Y.OUT.FILE.ID   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.TEMP.DIR      = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        Y.OUT.FILE.NAME = Y.OUT.FILE.ID
        Y.FIELD.NAME    = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VALUE   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISPLAY.TEXT  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
    END
*
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

    CHANGE @VM TO @FM IN Y.FIELD.VALUE
    CHANGE @VM TO @FM IN Y.DISPLAY.TEXT
*
    LOCATE "CONSUMO" IN Y.FIELD.NAME<1,1> SETTING Y.CON.POS THEN
        Y.CONSUMO.VALUE = Y.FIELD.VALUE<Y.CON.POS>
        Y.CONSUMO.TEXT  = Y.DISPLAY.TEXT<Y.CON.POS>
        Y.NAME.CONSUMO  = Y.CONSUMO.VALUE:" ":Y.CONSUMO.TEXT
    END
*
    LOCATE "HIPOTECARIO" IN Y.FIELD.NAME<1,1> SETTING Y.HIP.POS THEN
        Y.HIPOTECARIO.VALUE = Y.FIELD.VALUE<Y.HIP.POS>
        Y.HIPOTECARIO.TEXT  = Y.DISPLAY.TEXT<Y.HIP.POS>
        Y.NAME.HIPOTECARIO   = Y.HIPOTECARIO.VALUE:" ":Y.HIPOTECARIO.TEXT
    END
*
    LOCATE "COMERCIAL" IN Y.FIELD.NAME<1,1> SETTING Y.COM.POS THEN
        Y.COMERCIAL.VALUE = Y.FIELD.VALUE<Y.COM.POS>
        Y.COMERCIAL.TEXT  = Y.DISPLAY.TEXT<Y.COM.POS>
        Y.NAME.COMERCIAL  = Y.COMERCIAL.VALUE:" ":Y.COMERCIAL.TEXT
    END
*
    Y.TEMP.ID = ''
    FN.REDO.REPORT.TEMP = Y.TEMP.DIR
    F.REDO.REPORT.TEMP = ""
    CALL OPF(FN.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP)
*
RETURN
*-----------------------------------------------------------------------------------------------------------------
*
PROCESS:
*-------
*
*Frame Loop and Remove the id
*Read APAP.REPORT.TEMP If Record Exits then store it to an array
*Else Raise
*-----------------------------------------------------------------------------------------------------------------
    SEL.CMD = "SELECT ":FN.REDO.REPORT.TEMP:" LIKE ":Y.OUT.FILE.ID:"..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID:TEMP.POS
        CALL F.READ(FN.REDO.REPORT.TEMP,Y.TEMP.ID,R.REDO.REPORT.TEMP,F.REDO.REPORT.TEMP,TEMP.ERR)
        IF R.REDO.REPORT.TEMP NE '' THEN
            Y.TEMP.RECORD<-1> = R.REDO.REPORT.TEMP
            CALL F.DELETE(FN.REDO.REPORT.TEMP,Y.TEMP.ID)
        END ELSE
            GOSUB RAISE.ERR.C.22
        END
    REPEAT
    IF Y.TEMP.RECORD NE '' THEN
        GOSUB FORM.ARRAY
    END
RETURN
*
FORM.ARRAY:
*----------
    Y.NO.OF.LINES = DCOUNT(Y.TEMP.RECORD,@FM)
*
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.NO.OF.LINES
        Y.LINE   = Y.TEMP.RECORD<Y.CNT>
        Y.GROUP  = FIELD(Y.LINE,'*',1,1)
        Y.AMT    = FIELD(Y.LINE,'*',2,1)
        Y.REC    = FIELD(Y.LINE,'*',3,1)
*
        BEGIN CASE
            CASE Y.GROUP EQ 'CONSUMO'
                Y.GROUP1   = 'CONSUMO'
                Y.NAME1    = Y.NAME.CONSUMO
                Y.CON.TOTAL   += Y.AMT
                Y.CONSUMO<-1> = Y.REC
            CASE Y.GROUP EQ 'HIPOTECARIO'
                Y.GROUP2   = 'HIPOTECARIO'
                Y.NAME2    = Y.NAME.HIPOTECARIO
                Y.HIP.TOTAL += Y.AMT
                Y.HIPOTECARIO<-1> = Y.REC
            CASE Y.GROUP EQ 'COMERCIAL'
                Y.GROUP3   = 'COMERCIAL'
                Y.NAME3    = Y.NAME.COMERCIAL
                Y.COM.TOTAL += Y.AMT
                Y.COMERCIAL<-1> = Y.REC
        END CASE
        Y.CNT += 1 ;* R22 Auto conversion
    REPEAT
*
    IF Y.CONSUMO THEN
        Y.FINAL.ARRAY = ''; Y.FINAL.OUT.FILE.NAME = ''
        Y.CON.TOTAL = FMT(Y.CON.TOTAL,'15"0"R')
        Y.FINAL.ARRAY = Y.NAME1:@FM:Y.CONSUMO:@FM:Y.CON.TOTAL
        Y.FINAL.OUT.FILE.NAME = Y.OUT.FILE.NAME:'_':Y.GROUP1:'_':R.DATES(EB.DAT.LAST.WORKING.DAY):".txt"
        GOSUB WRITE.FILE
    END
*
    IF Y.HIPOTECARIO THEN
        Y.FINAL.ARRAY = ''; Y.FINAL.OUT.FILE.NAME = ''
        Y.HIP.TOTAL = FMT(Y.HIP.TOTAL,'15"0"R')
        Y.FINAL.ARRAY = Y.NAME2:@FM:Y.HIPOTECARIO:@FM:Y.HIP.TOTAL
        Y.FINAL.OUT.FILE.NAME = Y.OUT.FILE.NAME:'_':Y.GROUP2:'_':R.DATES(EB.DAT.LAST.WORKING.DAY):".txt"
        GOSUB WRITE.FILE
    END
*
    IF Y.COMERCIAL THEN
        Y.FINAL.ARRAY = ''; Y.FINAL.OUT.FILE.NAME = ''
        Y.COM.TOTAL   = FMT(Y.COM.TOTAL,'15"0"R')
        Y.FINAL.ARRAY = Y.NAME3:@FM:Y.COMERCIAL:@FM:Y.COM.TOTAL
        Y.FINAL.OUT.FILE.NAME = Y.OUT.FILE.NAME:'_':Y.GROUP3:'_':R.DATES(EB.DAT.LAST.WORKING.DAY):".txt"
        GOSUB WRITE.FILE
    END
RETURN
*
WRITE.FILE:
*----------

    R.FIL = ''; READ.FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,Y.FINAL.OUT.FILE.NAME,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,Y.FINAL.OUT.FILE.NAME
    END
    WRITE Y.FINAL.ARRAY ON F.CHK.DIR, Y.FINAL.OUT.FILE.NAME ON ERROR
        Y.ERR.MSG = "Unable to Write ":Y.FINAL.OUT.FILE.NAME
        GOSUB RAISE.ERR.C.22
        RETURN
    END
*
RAISE.ERR.C.22:
*--------------
*Handling error process
*---------------
    MON.TP = "04"
    Y.ERR.MSG = "Record not found"
    REC.CON = "Receperciones-":Y.ERR.MSG
    DESC = "Receperciones-":Y.ERR.MSG
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    BAT.NO   = ''
    BAT.TOT  = ''
    INFO.OR  = ''
    INFO.DE  = ''
    ID.PROC  = ''
    EX.USER  = ''
    EX.PC    = ''
    CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*R22 Manual Conversion
RETURN

END
