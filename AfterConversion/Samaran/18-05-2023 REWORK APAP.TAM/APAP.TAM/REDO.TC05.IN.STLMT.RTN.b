* @ValidationCode : MjotMjY4ODUyNDE0OkNwMTI1MjoxNjg0Mzk0MzYxNjE1OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 May 2023 12:49:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE  REDO.TC05.IN.STLMT.RTN(STLMT.LINES)
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.TC05.IN.STLMT.RTN
*Date              : 23.11.2010
*-------------------------------------------------------------------------
*Description:
*--------------
*This routine is used in process of building array for settlement line of transaction code 05
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --STLMT.LINES--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*23/11/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*23/11/2012      PRABHU N                     MANDIS 2920           Y.LINE.CNT++ removed
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*17/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION            FM TO @FM, VM TO @VM, ++ TO +=
*17/04/2023         SURESH           MANUAL R22 CODE CONVERSION          CALL Rtn format modified
*------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON
    $INSERT I_F.REDO.VISA.STLMT.PARAM
    $INSERT I_F.REDO.VISA.STLMT.05TO37
    $INSERT I_F.REDO.VISA.STLMT.MAPPING
    $INSERT I_F.REDO.VISA.OUTGOING
    $INSERT I_F.ATM.REVERSAL


    GOSUB INIT
    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------

    CONT.FLAG='FALSE'
    R.REDO.STLMT.LINE=''
    ERROR.MESSAGE=''
    AMT.CHECK='TRUE'
    FLAG=''
    TC.CODE.ALT=''
    CARD.NUMBER=''
    R.VISA.OUTGOING=''
    R.REDO.VISA.STLMT.MAPPING=''
    CHECK.ADD.DIGIT=''
    CARD.TYPE.VAL=''
    AUTH.CODE=''
    Y.ID=''
    Y.STL.ID=''
    R.VISA.OUTGOING=''
    R.ATM.REVERSAL=''
    ATM.REVERSAL.ID=''
    AUTO.CHG.BACK=''

RETURN

*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------

    STLMT.CNT=DCOUNT(STLMT.LINES,@FM)
    OTHR.TCR.ARR=''
    LINE.CNT=1
    LOOP

    WHILE LINE.CNT LE STLMT.CNT
        Y.CONTINUE.FLAG=1
        TCR.NO= STLMT.LINES<LINE.CNT>[4,1]
        IF TCR.NO NE 0 AND TCR.NO NE 1 THEN
            OTHR.TCR.ARR<1,-1>= STLMT.LINES<LINE.CNT>
*            LINE.CNT++
            Y.CONTINUE.FLAG=0
        END
        IF Y.CONTINUE.FLAG THEN
            Y.VISA.STLMT.ID=TC.CODE:TCR.NO
            CALL F.READ(FN.REDO.VISA.STLMT.MAPPING,Y.VISA.STLMT.ID,R.REDO.VISA.STLMT.MAPPING,F.REDO.VISA.STLMT.MAPPING,STLMT.ERR)

            IF R.REDO.VISA.STLMT.MAPPING NE '' THEN
                Y.FIELD.NAME=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.FIELD.NAME>
                CHANGE @VM TO @FM IN Y.FIELD.NAME

                LOCATE 'USAGE.CODE' IN Y.FIELD.NAME SETTING FLD.POS THEN
                    Y.USAGE.CODE.ST.POS=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.START.POS,FLD.POS>
                    Y.USAGE.CODE.ED.POS=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.END.POS,FLD.POS>
                    Y.USAGE.CODE.VAL= STLMT.LINES<LINE.CNT>[Y.USAGE.CODE.ST.POS,Y.USAGE.CODE.ED.POS]
                    IF Y.USAGE.CODE.VAL EQ 2 THEN
                        ERROR.MESSAGE='USAGE.CODE'
                    END
                END


                GOSUB FIELD.WISE.PROCESS

            END
        END
        LINE.CNT += 1 ;*AUTO R22 CODE CONVERSION

    REPEAT
    GOSUB FINAL.PROCESS

RETURN

*------------------------------------------------------------------------------------
FIELD.WISE.PROCESS:
*------------------------------------------------------------------------------------

    Y.VAR1=1
    Y.FIELD.CNT=DCOUNT(Y.FIELD.NAME,@FM)
    LOOP
    WHILE Y.VAR1 LE Y.FIELD.CNT


        Y.FIELD.ST.POS=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.START.POS,Y.VAR1>
        Y.FIELD.ED.POS=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.END.POS,Y.VAR1>
        Y.FIELD.VALUE=STLMT.LINES<LINE.CNT>[Y.FIELD.ST.POS,Y.FIELD.ED.POS]

        IF R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.VERIFY.IN.RTN,Y.VAR1> NE '' THEN
            Y.RTN.NAME=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.VERIFY.IN.RTN,Y.VAR1>
            CALL @Y.RTN.NAME
        END
        IF CONT.FLAG EQ 'TRUE' THEN
            GOSUB END1
        END
        Y.FIELD.NO=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.FIELD.NO,Y.VAR1>
        IF Y.FIELD.NO NE '' THEN
            R.REDO.STLMT.LINE<Y.FIELD.NO>=Y.FIELD.VALUE
        END

        Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT



RETURN

*------------------------------------------------------------------------------------
FINAL.PROCESS:
*------------------------------------------------------------------------------------


*Y.ID.TXN.LOG=CARD.NUMBER:R.REDO.STLMT.LINE<VISA.SETTLE.AUTH.CODE>
    IF ERROR.MESSAGE EQ '' THEN
*CALL APAP.TAM.REDO.VERIFY.TRANSACTION ;*MANUAL R22 CODE CONVERSION
        CALL APAP.TAM.RedoVerifyTransaction() ;*MANUAL R22 CODE CONVERSION
    END
*CALL APAP.TAM.REDO.STLMT.STATUS.UPDATE ;*MANUAL R22 CODE CONVERSION
    CALL APAP.TAM.redoStlmtStatusUpdate() ;*MANUAL R22 CODE CONVERSION

    IF R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.OTHR.TCR.STORE,POS.TC> EQ 'Y' THEN
        R.REDO.STLMT.LINE<VISA.SETTLE.OTHER.TCR.LINE>=OTHR.TCR.ARR
    END

    IF R.VISA.OUTGOING NE '' THEN
        Y.OTHR.TCR.ARR.CNT=DCOUNT(OTHR.TCR.ARR,@VM)
        VAR2=1
        LOOP
        WHILE VAR2 LE Y.OTHR.TCR.ARR.CNT
            OTHR.TCR.ARR<1,VAR2>[1,2]=TC.CODE.ALT
            VAR2 += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
        GOSUB UPDATE.VISA.OUT
    END
    GOSUB UPDATE.VISA.STLMT
    GOSUB UPDATE.ATM.REVERSAL

RETURN
*------------------------------------------------------------------------------------
UPDATE.VISA.OUT:
*------------------------------------------------------------------------------------

    R.VISA.OUTGOING<VISA.OUT.OTHER.TCR.LINE>=OTHR.TCR.ARR

    R.VISA.OUTGOING<VISA.OUT.STATUS>='VERIFYINFO'

    CALL LOAD.COMPANY(ID.COMPANY)
    FULL.FNAME = FN.REDO.VISA.OUTGOING
    ID.T  = 'A'
    ID.N ='15'
    ID.CONCATFILE = ''
    COMI = ''
    PGM.TYPE = '.IDA'
    ID.NEW = ''
    V$FUNCTION = 'I'
    ID.NEW.LAST = ''
    CALL GET.NEXT.ID(ID.NEW.LAST,'F')
    Y.ID= COMI
    R.VISA.OUTGOING<VISA.OUT.CHARGEBACK.REF.NO>=Y.ID[LEN(Y.ID)-5,6]
    Y.OUT.ID=Y.ID
*CALL APAP.TAM.REDO.VISA.OUTGOING.WRITE(Y.ID,R.VISA.OUTGOING) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.TAM.redoVisaOutgoingWrite(Y.ID,R.VISA.OUTGOING) ;*MANUAL R22 CODE CONVERSION


RETURN
*------------------------------------------------------------------------------------
UPDATE.VISA.STLMT:
*------------------------------------------------------------------------------------
    CALL LOAD.COMPANY(ID.COMPANY)
    FULL.FNAME = FN.REDO.VISA.STLMT.05TO37
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
    R.REDO.STLMT.LINE<VISA.SETTLE.FILE.DATE>=Y.FILE.DATE
    IF ERROR.MESSAGE NE 'USAGE.CODE' THEN
        R.REDO.STLMT.LINE<VISA.SETTLE.CHARGEBACK.REF.NO>=Y.ID
    END
*CALL APAP.TAM.REDO.VISA.SETTLE.WRITE(Y.STL.ID,R.REDO.STLMT.LINE) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.TAM.RedoVisaSettleWrite(Y.STL.ID,R.REDO.STLMT.LINE) ;*MANUAL R22 CODE CONVERSION


RETURN
*------------------------------------------------------------------------------------
UPDATE.ATM.REVERSAL:
*------------------------------------------------------------------------------------

    CARD.NUMBER=R.REDO.STLMT.LINE<VISA.SETTLE.ACCOUNT.NUMBER>
    CARD.NUM.EXT=R.REDO.STLMT.LINE<VISA.SETTLE.ACCT.NUM.EXT>

    IF CARD.NUM.EXT EQ 0 THEN
        CARD.NUMBER = R.REDO.STLMT.LINE<VISA.SETTLE.ACCOUNT.NUMBER>
    END ELSE
        CARD.NUMBER = CARD.NUMBER:FMT(CARD.NUM.EXT,"R0%3")
    END

    ATM.REV.ID=CARD.NUMBER:'.':R.REDO.STLMT.LINE<VISA.SETTLE.AUTH.CODE>
    CALL F.READ(FN.ATM.REVERSAL,ATM.REV.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.REVERSAL.ERR)
    IF R.ATM.REVERSAL NE '' AND ERROR.MESSAGE NE 'USAGE.CODE' AND ERROR.MESSAGE NE 'DUP.PROCESSED.TRANS' THEN
        R.ATM.REVERSAL<AT.REV.VISA.CHGBCK.REF>=Y.ID
        R.ATM.REVERSAL<AT.REV.VISA.STLMT.REF>=Y.STL.ID
        CALL F.WRITE(FN.ATM.REVERSAL,ATM.REV.ID,R.ATM.REVERSAL)
    END
RETURN

*------------------------------------------------------------------------------------
END1:
*------------------------------------------------------------------------------------
END
