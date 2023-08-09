<<<<<<< Updated upstream
* @ValidationCode : MjoyMTMxNzM4ODI6Q3AxMjUyOjE2OTAyNjQzNTU0MzU6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:22:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
=======
* @ValidationCode : MjoxOTc5MTU0NzI1OkNwMTI1MjoxNjg0ODU0MzgyNDU4OklUU1M6LTE6LTE6OTI6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 92
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
>>>>>>> Stashed changes
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CLEAR.RETURN.SELECT
*-----------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : ganesh r
* PROGRAM NAME : REDO.B.CLEAR.RETURN.SELECT
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 21.09.2010  ganesh r           ODR-2010-09-0251   INITIAL CREATION
<<<<<<< Updated upstream
* Date                  who                   Reference
=======
* Date                  who                   Reference              
>>>>>>> Stashed changes
* 10-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION FM TO @FM
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.MAPPING.TABLE
    $INSERT I_F.REDO.CLEARING.PROCESS
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.B.CLEAR.RETURN.COMMON
<<<<<<< Updated upstream
    $USING APAP.REDOCHNLS
=======
>>>>>>> Stashed changes
*------------------------------------------------------------------------------------------

    GOSUB PROCESS
RETURN

PROCESS:
*------------------------------------------------------------------------------------------
    INT.CODE = ''
    ID.PROC = ''
    BAT.NO =''
    BAT.TOT =''
    INFO.OR =''
    INFO.DE =''
    ID.PROC = ''
    MON.TP =''
    DESC = ''
    REC.CON = ''
    EX.USER = ''
    EX.PC = ''
    VAR.APERTA.ID = TODAY:'.':VAR.FILE.NAME
    TEMP.APERTA.ID = VAR.APERTA.ID
    SEL.CMD = "SELECT ":VAR.FILE.PATH
    CALL EB.READLIST(SEL.CMD,FILE.LIST,'',NO.OF.REC,RET.ERR)
    R.APERTA.FINAL = ''

    LOOP
        REMOVE VAR.APERTA.ID FROM FILE.LIST SETTING FILE.POS
    WHILE VAR.APERTA.ID:FILE.POS
        CALL F.READ(FN.APERTA,VAR.APERTA.ID,R.APERTA,F.APERTA,APERTA.ERR)
        IF R.APERTA THEN
            Y.CRLF = CHARX(013):CHARX(010)
            Y.CR = CHARX(013)
            Y.LF = CHARX(010)
            CHANGE Y.CRLF TO @FM IN R.APERTA   ;* Convert NewLine/Carriage Return Charecter to FM
            CHANGE Y.CR TO @FM IN R.APERTA
            CHANGE Y.LF TO @FM IN R.APERTA
            CHANGE @FM:'':@FM TO @FM IN R.APERTA

            CALL OCOMO("Appending the file in Select - ":VAR.APERTA.ID )
            R.APERTA.FINAL<-1> = R.APERTA
*CALL BATCH.BUILD.LIST('',R.APERTA)
        END
        ELSE
            INT.CODE ='APA005'
            INT.TYPE ='BATCH'
            BAT.NO =''
            BAT.TOT =''
            INFO.OR =''
            INFO.DE =''
            ID.PROC = VAR.APERTA.ID
            MON.TP ='03'
            DESC = APERTA.ERR
            REC.CON = ''
            EX.USER = ''
            EX.PC = ''
<<<<<<< Updated upstream
*           CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
            APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
=======
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
>>>>>>> Stashed changes
            CALL OCOMO("Log Interface has been called since file is empty")
        END
    REPEAT
    CHANGE @FM:'':@FM TO @FM IN R.APERTA.FINAL
    TOTAL.LINES = DCOUNT(R.APERTA.FINAL,@FM)

    CALL OCOMO("No of lines to be build for process - ": TOTAL.LINES)
    CALL BATCH.BUILD.LIST('',R.APERTA.FINAL)

RETURN

END
