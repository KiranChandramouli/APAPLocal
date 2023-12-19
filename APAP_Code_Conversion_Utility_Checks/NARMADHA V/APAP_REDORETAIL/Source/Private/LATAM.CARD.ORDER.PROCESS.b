* @ValidationCode : MjotMTI4OTA2MTU5MTpDcDEyNTI6MTcwMTEwOTk2MzQwMDpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 28 Nov 2023 00:02:43
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
$PACKAGE APAP.REDORETAIL

SUBROUTINE LATAM.CARD.ORDER.PROCESS
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : LATAM.CARD.ORDER.PROCESS
*--------------------------------------------------------------------------------------------------------
*Description  : This is a process routine to update REDO.CARD.NUMBERS and REDO.CARD.NO.LOCK
*Linked With  : LATAM.CARD.ORDER
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 3 Aug 2010    Mohammed Anies K     ODR-2010-03-0400          Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*06-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*06-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*27-11-2023	       VIGNESHWARI                ADDED COMMENT FOR INTERFACE CHANGES     Embozado  � By Santiago
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.NUMBERS
    $INSERT I_F.REDO.CARD.NO.LOCK
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.REDO.STOCK.REGISTER
    $INSERT I_LATAM.CARD.COMMON
*--------------------------------------------------------------------------------------------------------
;***********	;*Fix Embozado � By Santiago-commented-start
*MAIN.PARA:
;***********	;*Fix Embozado � By Santiago-end

    IF R.OLD(CARD.IS.EMBOSS.TYPE) EQ 'PREEMBOZADA' AND R.OLD(CARD.IS.CARD.STATUS) EQ '97' AND R.NEW(CARD.IS.CARD.STATUS) NE '97' THEN

        AF=CARD.IS.CARD.STATUS
        ETEXT = "EB-CARD.STATUS.NT.ALLOW"
        CALL STORE.END.ERROR

    END

    IF R.OLD(CARD.IS.EMBOSS.TYPE) EQ 'PERSONALIZADA' AND R.OLD(CARD.IS.CARD.STATUS) EQ '97' AND  R.OLD(CARD.IS.RENEW.STATUS) NE "AVAILABLE"  AND R.NEW(CARD.IS.CARD.STATUS) NE '97' THEN

        AF=CARD.IS.CARD.STATUS
        ETEXT = "EB-CARD.STATUS.NT.ALLOW"
        CALL STORE.END.ERROR
    END


    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA


    Y.OLD.CRD.STATUS = R.OLD(CARD.IS.CARD.STATUS)
    IF (Y.OLD.CRD.STATUS EQ  '93' OR Y.OLD.CRD.STATUS EQ '95' OR Y.OLD.CRD.STATUS EQ '52' OR Y.OLD.CRD.STATUS EQ '35') AND Y.OLD.CRD.STATUS NE R.NEW(CARD.IS.CARD.STATUS) THEN
        AF=CARD.IS.CARD.STATUS
        ETEXT = "EB-CARD.STATUS.NT.ALLOW"
        CALL STORE.END.ERROR

    END


    IF R.NEW(CARD.IS.CARD.STATUS) EQ 90 THEN
        GOSUB UPDATE.STOCK.COUNT

    END

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened

    FN.LATAM.CARD.ORDER = 'F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER = ''
    R.LATAM.CARD.ORDER = ''

    FN.REDO.CARD.NO.LOCK = 'F.REDO.CARD.NO.LOCK'
    F.REDO.CARD.NO.LOCK = ''
    R.REDO.CARD.NO.LOCK = ''

    FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
    F.REDO.CARD.NUMBERS = ''
    R.REDO.CARD.NUMBERS = ''

    FN.REDO.STK.REG = 'F.REDO.STOCK.REGISTER'
    F.REDO.STK.REG = ''
    CALL OPF(FN.REDO.STK.REG,F.REDO.STK.REG)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section

    Y.LATAM.CARD.ORDER.ID = ID.NEW
    Y.CARD.TYPE  = FIELD(Y.LATAM.CARD.ORDER.ID,'.',1)
    Y.CARD.NO.AND.LOCK.ID = Y.CARD.TYPE:'.':ID.COMPANY
    IF V$FUNCTION EQ 'I' THEN
        CALL F.READ(FN.REDO.CARD.NUMBERS,Y.CARD.NO.AND.LOCK.ID,R.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS,ERR.CARD)
        IF R.REDO.CARD.NUMBERS THEN
            Y.NEW.CARD.NO = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER>
            CHANGE @VM TO @FM IN Y.NEW.CARD.NO
            Y.COUNT = DCOUNT(Y.NEW.CARD.NO,@FM)
            CNT = '1'
            NEW.CARD.NO = ''
            Y.FLAG = '0'
            LOOP
            WHILE Y.COUNT GE CNT
                Y.CARD.NO = Y.NEW.CARD.NO<Y.COUNT>
                Y.CARD.STATUS = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS,Y.COUNT>
                IF Y.CARD.STATUS EQ "AVAILABLE" THEN
                    Y.FLAG += 1
                    IF Y.FLAG GT '3' THEN
                        BREAK
                    END
                END
                Y.COUNT -= 1
            REPEAT

            IF Y.FLAG LT "3" THEN
                TEXT = "EB-TOT.NO.CARD.BLW2"
                CALL STORE.OVERRIDE(CURR.NO)
            END

        END
    END

    IF V$FUNCTION EQ 'D' THEN
        Y.CARD.NO = FIELD(Y.LATAM.CARD.ORDER.ID,'.',2)

        GOSUB READ.REDO.CARD.NUMBERS
        IF R.REDO.CARD.NUMBERS THEN
            LOCATE Y.CARD.NO IN R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER,1> SETTING Y.CARD.POS THEN

                R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS,Y.CARD.POS> = 'AVAILABLE'
                CALL F.WRITE(FN.REDO.CARD.NUMBERS,Y.CARD.NO.AND.LOCK.ID,R.REDO.CARD.NUMBERS)

            END
        END
    END

    IF NOT(ID.OLD) THEN
        IF V$FUNCTION EQ 'I' THEN
            Y.CARD.NO = FIELD(Y.LATAM.CARD.ORDER.ID,'.',2)

            GOSUB READ.REDO.CARD.NUMBERS
            IF R.REDO.CARD.NUMBERS THEN
                LOCATE Y.CARD.NO IN R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER,1> SETTING Y.CARD.POS THEN

                    R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS,Y.CARD.POS> = 'INUSE'
                    CALL F.WRITE(FN.REDO.CARD.NUMBERS,Y.CARD.NO.AND.LOCK.ID,R.REDO.CARD.NUMBERS)

                END
            END

        END
    END



RETURN
*--------------------------------------------------------------------------------------------------------
READ.REDO.CARD.NO.LOCK:
**********************
*
    R.REDO.CARD.NO.LOCK = ''
    REDO.CARD.NO.LOCK.ERR = ''
    Y.OPTIONS = ''
    CALL F.READU(FN.REDO.CARD.NO.LOCK,Y.CARD.NO.AND.LOCK.ID,R.REDO.CARD.NO.LOCK,F.REDO.CARD.NO.LOCK,REDO.CARD.NO.LOCK.ERR,Y.OPTIONS)

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
READ.REDO.CARD.NUMBERS:
**********************
*
    R.REDO.CARD.NUMBERS = ''
    REDO.CARD.NUMBERS.ERR = ''
    Y.OPTIONS = ''
    CALL F.READU(FN.REDO.CARD.NUMBERS,Y.CARD.NO.AND.LOCK.ID,R.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS,REDO.CARD.NUMBERS.ERR,Y.OPTIONS)

RETURN
*--------------------------------------------------------------------------------------------------------
UPDATE.STOCK.COUNT:
*PACS00056634 -S

    STOCK.REG.ID = R.NEW(CARD.IS.STOCK.REG.ID)
    STOCK.SERIES = R.NEW(CARD.IS.STOCK.SERIERS.ID)
    OLD.CARD.STATUS = R.OLD(CARD.IS.CARD.STATUS)
    NEW.CARD.STATUS = R.NEW(CARD.IS.CARD.STATUS)

    Y.CURR.NO = R.NEW(CARD.IS.CURR.NO)
    R.REDO.STK.REG = ''
    Y.OPTIONS = ''

    CALL F.READU(FN.REDO.STK.REG,STOCK.REG.ID,R.REDO.STK.REG,F.REDO.STK.REG,REG.ERR,Y.OPTIONS)
    IF R.REDO.STK.REG THEN
        IF NOT(Y.CURR.NO) OR (OLD.CARD.STATUS EQ 92 AND NEW.CARD.STATUS EQ 90) OR (R.NEW(CARD.IS.RENEW.STATUS) EQ "AVAILABLE") THEN
            SERIES.ID = R.REDO.STK.REG<STK.REG.SERIES.ID>
            CHANGE @VM TO @FM IN SERIES.ID
            LOCATE STOCK.SERIES IN SERIES.ID SETTING SER.POS THEN
                R.REDO.STK.REG<STK.REG.SERIES.BAL,SER.POS>  = R.REDO.STK.REG<STK.REG.SERIES.BAL,SER.POS> - 1
                R.REDO.STK.REG<STK.REG.STO.REG.BAL> = R.REDO.STK.REG<STK.REG.STO.REG.BAL> - 1
            END
        END
    END

    CALL F.WRITE(FN.REDO.STK.REG,STOCK.REG.ID,R.REDO.STK.REG)

*  PACS00056634 -E

RETURN
*--------------------------------------
END
