* @ValidationCode : MjoxMjg3NjY4ODMwOkNwMTI1MjoxNjgyNTk4MDA5OTQwOnNhbWFyOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Apr 2023 17:50:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE LATAM.CARD.ORDER.ID
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : LATAM.CARD.ORDER.ID
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to
*Linked With  : LATAM.CARD.ORDER
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 3 Aug 2010    Mohammed Anies K       ODR-2010-03-0400          Initial Creation
* 13 Dec 2010   BALAGURUNATHAN B       ODR-2010-08-0469          Added logic to default Channels Not Allowed for card
* 13-MAY-2011       KAVITHA             ODR-2010-08-0467          PACS00055017  FIX
* 13 JUL 2011       KAVITHA            *PACS00082440              *PACS00082440
* 11-Aprl-2022      Soundarya S         PACS00957745              System is updating the REDO.CARD.NO.LOCK incorrectly
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*06-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1 , = TO EQ
*06-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CARD.NUMBERS
    $INSERT I_F.REDO.CARD.NO.LOCK
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_AT.ISO.COMMON
    $INSERT I_LATAM.CARD.COMMON
    $INSERT I_F.REDO.CARD.REQUEST
    $USING APAP.TAM
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB OPEN.PARA

    IF NOT(RUNNING.UNDER.BATCH) THEN
        GOSUB ONLINE.PROCESS
    END ELSE
        GOSUB PROCESS.PARA
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*-----------------
ONLINE.PROCESS:
*-----------------

    IF GTSACTIVE THEN
        IF OFS$OPERATION EQ 'BUILD' THEN
            GOSUB PROCESS.PARA

        END ELSE
            IF OFS$REQUEST.TYPE EQ 'VANILLA.OFS' THEN
                GOSUB PROCESS.PARA

            END
        END
    END ELSE
        GOSUB PROCESS.PARA
    END
RETURN
**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened

    FN.LATAM.CARD.ORDER = 'F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER = ''
    R.LATAM.CARD.ORDER = ''
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)

    FN.LATAM.CARD.ORDER.NAU = 'F.LATAM.CARD.ORDER$NAU'
    F.LATAM.CARD.ORDER.NAU = ''
    R.LATAM.CARD.ORDER.NAU = ''
    CALL OPF(FN.LATAM.CARD.ORDER.NAU,F.LATAM.CARD.ORDER.NAU)

    FN.REDO.CARD.NO.LOCK = 'F.REDO.CARD.NO.LOCK'
    F.REDO.CARD.NO.LOCK = ''
    R.REDO.CARD.NO.LOCK = ''
    CALL OPF(FN.REDO.CARD.NO.LOCK,F.REDO.CARD.NO.LOCK)

    FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
    F.REDO.CARD.NUMBERS = ''
    R.REDO.CARD.NUMBERS = ''
    CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)
    EXIT.FLAG = ''
    NOT.AVAIL.FLAG = ''

    FN.REDO.CARD.REQUEST='F.REDO.CARD.REQUEST'
    F.REDO.CARD.REQUEST=''
    CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section


    IF AT$AT.REQ.MAP.ID THEN
*CALL APAP.TAM.REDO.CHK.REC.PIN.EXCEED
        CALL APAP.TAM.redoChkRecPinExceed();*MANUAL R22 CODE CONVERSION
        
    END
    Y.LATAM.CARD.ORDER.ID = ID.NEW

    GET.PRIN.CARD.NO = ID.NEW
    FINDSTR '.' IN GET.PRIN.CARD.NO SETTING DOT.POS THEN
        Y.ID.SPLIT = FIELD(GET.PRIN.CARD.NO,".",2)

        BEGIN CASE
            CASE Y.ID.SPLIT NE 'NEW'

                GOSUB READ.LATAM.CARD.ORDER
                IF R.LATAM.CARD.ORDER THEN
                    RETURN
                END
                GOSUB READ.LATAM.CARD.ORDER.NAU
                IF R.LATAM.CARD.ORDER.NAU EQ '' THEN

                    Y.ID.TYPE=FIELD(Y.LATAM.CARD.ORDER.ID,'.',1)
                    Y.ID.NUMBERS=Y.ID.TYPE:'.':ID.COMPANY
                    CALL F.READ(FN.REDO.CARD.NUMBERS,Y.ID.NUMBERS,R.REDO.CRD.NUMBERS,F.REDO.CARD.NUMBERS,ERR.CARD)

                    IF R.REDO.CRD.NUMBERS THEN
                        LOCATE Y.ID.SPLIT IN R.REDO.CRD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER,1> SETTING NUM.POS THEN
                            EMB.TYPE= R.REDO.CRD.NUMBERS<REDO.CARD.NUM.EMBOSS.TYPE,NUM.POS>
                            EMB.STAT= R.REDO.CRD.NUMBERS<REDO.CARD.NUM.STATUS,NUM.POS>
                            IF EMB.TYPE EQ 'PERSONALIZADA' AND  EMB.STAT EQ 'INUSE' THEN
                                RETURN
                            END
                        END
                    END

                    E='ST-LATAM.CARD.ID.ERR'
                    CALL STORE.END.ERROR
                    RETURN
                END

            CASE Y.ID.SPLIT EQ 'NEW'
                GOSUB NEW.CARD.FETCH
        END CASE

    END ELSE

        PRIN.CARD.NO = GET.PRIN.CARD.NO
        GOSUB GET.LATAM.ID

    END

RETURN
*---------------------------------------------------------------------------
GET.LATAM.ID:

    NO.SEL.CMD = 'SELECT ':FN.REDO.CARD.NUMBERS:" WITH @ID LIKE ...":ID.COMPANY

    CALL EB.READLIST(NO.SEL.CMD,SEL.LIST,'',NO.OF.IDS,SEL.RET)
    LOOP
        REMOVE Y.CARD.NO FROM SEL.LIST SETTING POS
    WHILE Y.CARD.NO:POS
        Y.CARD.NO.AND.LOCK.ID = Y.CARD.NO
        GOSUB READ.REDO.CARD.NUMBERS

        LOCATE ID.NEW IN R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER,1> SETTING LOC.CRD.POS THEN

            GOSUB LOCATE.CARD.NO.CHECK
            IF EXIT.FLAG EQ 1 THEN ;*AUTO R22 CODE CONVERSION
                RETURN
            END

        END ELSE
            NOT.AVAIL.FLAG = 1
        END

    REPEAT

    IF NOT.AVAIL.FLAG EQ 1 THEN ;*AUTO R22 CODE CONVERSION
        E = 'ST-CARD.ID.NO.AVAIL'
    END

*PACS00082440 -E
RETURN
*------------------------------------------------------------------------
LOCATE.CARD.NO.CHECK:


    FETCH.PERS.STATUS = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS,LOC.CRD.POS>
    CARD.TYPE.CONCAT = FIELD(Y.CARD.NO.AND.LOCK.ID,".",1)

    GOSUB READ.LATAM.CARD.ORDER

    IF R.LATAM.CARD.ORDER THEN
        ID.NEW = Y.LATAM.CARD.ORDER.ID
        EXIT.FLAG = 1
        NOT.AVAIL.FLAG = ''
        RETURN
    END

    GOSUB READ.LATAM.CARD.ORDER.NAU
    IF R.LATAM.CARD.ORDER.NAU THEN
        ID.NEW = Y.LATAM.CARD.ORDER.ID
        EXIT.FLAG = 1
        NOT.AVAIL.FLAG = ''
        RETURN
    END ELSE
        IF TRIM(FETCH.PERS.STATUS) EQ "INUSE" THEN
            CARD.TYPE.CONCAT = FIELD(Y.CARD.NO.AND.LOCK.ID,".",1)
            ID.NEW = CARD.TYPE.CONCAT:".":PRIN.CARD.NO

*            CALL F.WRITE(FN.REDO.CARD.NUMBERS,Y.CARD.NO.AND.LOCK.ID,R.REDO.CARD.NUMBERS)
            WRITE R.REDO.CARD.NUMBERS TO F.REDO.CARD.NUMBERS,Y.CARD.NO.AND.LOCK.ID
            NOT.AVAIL.FLAG = ''
            EXIT.FLAG = 1
        END ELSE
            NOT.AVAIL.FLAG = 1
        END
    END

RETURN
*--------------------------------------
NEW.CARD.FETCH:

    NEW.CARD.NO = ''
    Y.NEW.CARD=1
    Y.PROCESS=0

    Y.CARD.TYPE = FIELD(Y.LATAM.CARD.ORDER.ID,'.',1)
    Y.ID.NUMBERS = Y.CARD.TYPE:'.':ID.COMPANY

    R.REDO.CARD.NUMBERS = ''
    REDO.CARD.NUMBERS.ERR = ''
    CALL F.READU(FN.REDO.CARD.NUMBERS,Y.ID.NUMBERS,R.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS,REDO.CARD.NUMBERS.ERR,'')
    IF R.REDO.CARD.NUMBERS THEN
        Y.NEW.CARD.NO = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER>
        CHANGE @VM TO @FM IN Y.NEW.CARD.NO ;*AUTO R22 CODE CONVERSION
        Y.COUNT = DCOUNT(Y.NEW.CARD.NO,@FM) ;*AUTO R22 CODE CONVERSION
        CNT = '1'
        LOOP
        UNTIL NEW.CARD.NO OR CNT GT Y.COUNT       ;* Keep looping till we get a proper Card.
            Y.CARD.NO = Y.NEW.CARD.NO<CNT>
            Y.CARD.STATUS = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS,CNT>
            IF Y.CARD.STATUS EQ "AVAILABLE" THEN
                Y.LATAM.CARD.ORDER.ID = Y.CARD.TYPE:'.':Y.CARD.NO
                R.LATAM.CARD.ORDER.NAU = ''
                LATAM.CARD.ORDER.NAU.ERR = ''
                CALL F.READU(FN.LATAM.CARD.ORDER.NAU,Y.LATAM.CARD.ORDER.ID,R.LATAM.CARD.ORDER.NAU,F.LATAM.CARD.ORDER.NAU,LATAM.CARD.ORDER.NAU.ERR,'1')
                IF LATAM.CARD.ORDER.NAU.ERR EQ 'RECORD NOT FOUND' THEN
                    NEW.CARD.NO = Y.CARD.NO       ;* Exit the loop, once we get a card.
                END
            END
            CNT += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
    END

    IF NEW.CARD.NO EQ '' THEN
        E = 'ST-CARD.ID.NO.AVAIL'
        CALL STORE.END.ERROR
    END ELSE
        ID.NEW = Y.CARD.TYPE:'.':NEW.CARD.NO
    END
RETURN
*--------------------------------------------------------------------------------------------------------
**********************
READ.LATAM.CARD.ORDER:
**********************
*
    R.LATAM.CARD.ORDER = ''
    LATAM.CARD.ORDER.ERR = ''
    CALL F.READ(FN.LATAM.CARD.ORDER,Y.LATAM.CARD.ORDER.ID,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,LATAM.CARD.ORDER.ERR)

RETURN
*--------------------------------------------------------------------------------------------------------
*************************
READ.LATAM.CARD.ORDER.NAU:
*************************
*
    R.LATAM.CARD.ORDER.NAU = ''
    LATAM.CARD.ORDER.NAU.ERR = ''
    CALL F.READ(FN.LATAM.CARD.ORDER.NAU,Y.LATAM.CARD.ORDER.ID,R.LATAM.CARD.ORDER.NAU,F.LATAM.CARD.ORDER.NAU,LATAM.CARD.ORDER.NAU.ERR)

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
READ.REDO.CARD.NUMBERS:
**********************

    R.REDO.CARD.NUMBERS = ''
    REDO.CARD.NUMBERS.ERR = ''
    CALL F.READU(FN.REDO.CARD.NUMBERS,Y.CARD.NO.AND.LOCK.ID,R.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS,REDO.CARD.NUMBERS.ERR,'')

RETURN
*--------------------------------------------------------------------------------------------------------
END
