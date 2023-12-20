* @ValidationCode : MjotMTM0MTIyMTgyMTpDcDEyNTI6MTcwMjk4ODI1MDg4MDpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:47:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
SUBROUTINE REDO.TC25.IN.STLMT.RTN(STLMT.LINES)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.TC25.IN.STLMT.RTN
* ODR NO      : ODR-2010-08-0469
*----------------------------------------------------------------------
*DESCRIPTION:  This is an Settlment routine for TC25



*IN PARAMETER: STLMT.LINES
*OUT PARAMETER: NA
*LINKED WITH: REDO.VISA.STLMT.RJ.05TO37
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*03.12.2010  H GANESH     ODR-2010-08-0469   INITIAL CREATION
*10.04.2023 Conversion Tool    R22           Auto Conversion     - No changes
*10.04.2023 Shanmugapriya M    R22           Manual Conversion   - Add call routine prefix ,CALL RTN FORMAT MODIFIED
*
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON
    $INSERT I_F.REDO.VISA.STLMT.05TO37
    $INSERT I_F.REDO.VISA.STLMT.MAPPING
    $INSERT I_F.REDO.VISA.STLMT.PARAM
    $INSERT I_F.REDO.DC.STLMT.ERR.CODE
    $INSERT I_F.ATM.REVERSAL
    $USING APAP.TAM
    $USING ST.CompanyCreation


    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

*CALL REDO.TC.IN.FRAME.ARR(STLMT.LINES)
** R22 Manual conversion
*CALL APAP.TAM.REDO.TC.IN.FRAME.ARR(STLMT.LINES) ;*R22 MANUAL CODE CONVERSION
    APAP.TAM.redoTcInFrameArr(STLMT.LINES)
*CALL REDO.TC25.IN.VERIFY.RTN
** R22 Manual conversion
*CALL APAP.TAM.REDO.TC25.IN.VERIFY.RTN ;*R22 MANUAL CODE CONVERSION
    APAP.ATM.redoTc25InVerifyRtn() ;*R22 MANUAL CODE CONVERSION
    R.REDO.STLMT.LINE<VISA.SETTLE.FILE.DATE>=Y.FILE.DATE


    IF R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.OTHR.TCR.STORE,POS.TC> EQ 'Y' THEN
        R.REDO.STLMT.LINE<VISA.SETTLE.OTHER.TCR.LINE>=OTHR.TCR.ARR
    END


    IF ERROR.MESSAGE EQ '' THEN
        R.REDO.STLMT.LINE<VISA.SETTLE.REASON.CODE>=82
    END ELSE
        LOCATE ERROR.MESSAGE IN R.REDO.DC.STLMT.ERR.CODE<STM.ERR.CODE.ERR.MSG,1> SETTING ERROR.POS THEN
            R.REDO.STLMT.LINE<VISA.SETTLE.REASON.CODE> = R.REDO.DC.STLMT.ERR.CODE<STM.ERR.CODE.ERR.CODE,ERROR.POS>
        END
    END

    IF ERROR.MESSAGE EQ 'USAGE.CODE' THEN
        R.REDO.STLMT.LINE<VISA.SETTLE.FINAL.STATUS> = 'REPRESENTMENT'
    END
    ELSE
        R.REDO.STLMT.LINE<VISA.SETTLE.FINAL.STATUS> ='REJECTED'
    END
*CALL LOAD.COMPANY(ID.COMPANY)
    ST.CompanyCreation.LoadCompany(ID.COMPANY) ;*r22 manual code conversion
    FULL.FNAME = 'F.REDO.VISA.STLMT.05TO37'
    ID.T  = 'A'
    ID.N ='15'
    ID.CONCATFILE = ''
    COMI = ''
    PGM.TYPE = '.IDA'
    ID.NEW = ''
    V$FUNCTION = 'I'
    ID.NEW.LAST = ''
    CALL GET.NEXT.ID(ID.NEW.LAST,'F')
    Y.STL.ID = COMI
    IF R.ATM.REVERSAL THEN
        R.ATM.REVERSAL<AT.REV.CR.VOUCHER.REF>=Y.STL.ID
        CALL F.WRITE(FN.ATM.REVERSAL,ATM.REVERSAL.ID,R.ATM.REVERSAL)
    END
*CALL REDO.VISA.SETTLE.WRITE(Y.STL.ID,R.REDO.STLMT.LINE)
** R22 Manual conversion
*CALL APAP.TAM.REDO.VISA.SETTLE.WRITE(Y.STL.ID,R.REDO.STLMT.LINE) ;*R22 MANUAL CODE CONVERSION
    APAP.TAM.redoVisaSettleWrite(Y.STL.ID,R.REDO.STLMT.LINE) ;*R22 MANUAL CODE CONVERSION

RETURN
END
