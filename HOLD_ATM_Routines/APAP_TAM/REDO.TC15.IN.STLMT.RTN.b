* @ValidationCode : MjotODkyMTg1MDU1OkNwMTI1MjoxNjgzNzI4ODY1MjQxOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 May 2023 19:57:45
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
$PACKAGE APAP.TAM

SUBROUTINE REDO.TC15.IN.STLMT.RTN(STLMT.LINES)
*--------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.TC15.IN.STLMT.RTN
*Date              : 23.11.2010

*Description:
*-------------
*This routine is used in process of building array for settlement line of transaction code 15,16,17
*---------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*23/11/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
** 17-04-2023 R22 Auto Conversion no changes
** 17-04-2023 Skanda R22 Manual Conversion - Add call routine prefix
*------------------------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_F.REDO.VISA.STLMT.05TO37
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON
    $USING APAP.TAM

    GOSUB PROCESS

RETURN

*---------------------------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------------------------

*CALL REDO.TC.IN.FRAME.ARR(STLMT.LINES)
** R22 Manual conversion
    CALL APAP.TAM.redoTcInFrameArr(STLMT.LINES)
*CALL  REDO.STLMT.VERIFY.MSG()       ;* Removed
*STATUS.DEFAULT= R.REDO.VISA.STLMT.MAPPING<UPDATE.STATUS>  ;* Removed


    CARD.NUMBER=R.REDO.STLMT.LINE<VISA.SETTLE.ACCOUNT.NUMBER>
    CARD.NUM.EXT=R.REDO.STLMT.LINE<VISA.SETTLE.ACCT.NUM.EXT>

    IF CARD.NUM.EXT EQ 0 THEN
        CARD.NUMBER = R.REDO.STLMT.LINE<VISA.SETTLE.ACCOUNT.NUMBER>
    END ELSE
        CARD.NUMBER = CARD.NUMBER:FMT(CARD.NUM.EXT,"R0%3")
    END

    ATM.REV.ID=CARD.NUMBER:'.':R.REDO.STLMT.LINE<VISA.SETTLE.ACQR.REF.NUM>
    CALL F.READ(FN.ATM.REVERSAL,ATM.REV.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.REVERSAL.ERR)

    Y.VISA.CHGBCK.REF=R.ATM.REVERSAL<AT.REV.VISA.CHGBCK.REF>
    IF Y.VISA.CHGBCK.REF NE '' THEN
        R.REDO.STLMT.LINE<VISA.SETTLE.FINAL.STATUS>='POSDUP'
    END ELSE
        R.REDO.STLMT.LINE<VISA.SETTLE.STATUS>='PENDING'
    END
    Y.ID.COMPANY=ID.COMPANY
    CALL LOAD.COMPANY(Y.ID.COMPANY)
    ID.COMPANY=Y.ID.COMPANY
    FULL.FNAME = 'F.REDO.VISA.STLMT.05TO37'
    ID.T  = 'A'
    ID.N ='15'
    ID.CONCATFILE = ''
    COMI = ''
    PGM.TYPE = '.IDA'
    ID.NEW = ''
    V$FUNCTION = 'I'
    ID.NEW.LAST=''
    IDNEW.LAST = ID.NEW.LAST
    CALL GET.NEXT.ID(IDNEW.LAST,'F')
    ID.NEW.LAST=IDNEW.LAST
    Y.STL.ID= COMI
    R.REDO.STLMT.LINE<VISA.SETTLE.FILE.DATE>=Y.FILE.DATE
*CALL REDO.VISA.SETTLE.WRITE(Y.STL.ID,R.REDO.STLMT.LINE)
** R22 Manual conversion
    CALL APAP.TAM.redoVisaSettleWrite(Y.STL.ID,R.REDO.STLMT.LINE)
    IF R.REDO.STLMT.LINE<VISA.SETTLE.STATUS> EQ 'PENDING' THEN
        R.ATM.REVERSAL<AT.REV.VISA.CHGBCK.REF>=Y.STL.ID
        CALL F.WRITE(FN.ATM.REVERSAL,ATM.REV.ID,R.ATM.REVERSAL)
    END


RETURN
END