* @ValidationCode : MjotMTM2MzQ5NzI1NTpDcDEyNTI6MTY4NDIyMjc3MTcxMTpJVFNTOi0xOi0xOjU1MzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:09:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 553
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   $INSERT MODIFIED , T24.BP IS REMOVED FROM INSERT
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE AUTH.CARD.ORDER.ID.BUG
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : APAP
*Program   Name    : AUTH.CARD.ORDER.ID.BUG
*--------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 5 april 2022   Estalin Valerio                                 Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CARD.NUMBERS
    $INSERT I_F.REDO.CARD.NO.LOCK
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_AT.ISO.COMMON
    $INSERT I_LATAM.CARD.COMMON
    $INSERT I_F.REDO.CARD.REQUEST ;*R22 AUTO CODE CONVERSION
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB OPEN.PARA
    GOSUB NEW.CARD.FETCH

RETURN
*--------------------------------------------------------------------------------------------------------

**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened

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

NEW.CARD.FETCH:

    Y.LATAM.CARD.ORDER.ID = ID.NEW
    Y.NEW.CARD=1
    Y.PROCESS=0

    Y.CARD.TYPE = 'TDVV' *FIELD(COMI,'.',1)
    Y.CARD.NO.AND.LOCK.ID = 'TDVV.DO0010001'
*Y.CARD.TYPE:'.':ID.COMPANY

    GOSUB READ.REDO.CARD.NO.LOCK

    IF R.REDO.CARD.NO.LOCK THEN
        Y.NEW.CARD.NO = R.REDO.CARD.NO.LOCK<REDO.CARD.LOCK.CARD.NUMBER,1>
    END
    ELSE
        Y.NEW.CARD.NO = ''
    END

    GOSUB UPDATE.REDO.CARD.NOS.AND.LOCK

RETURN
*--------------------------------------------------------------------------------------------------------

**********************
READ.REDO.CARD.NO.LOCK:
**********************

    R.REDO.CARD.NO.LOCK = ''
    REDO.CARD.NO.LOCK.ERR = ''
    CALL F.READU(FN.REDO.CARD.NO.LOCK,Y.CARD.NO.AND.LOCK.ID,R.REDO.CARD.NO.LOCK,F.REDO.CARD.NO.LOCK,REDO.CARD.NO.LOCK.ERR,'')

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
*****************************
UPDATE.REDO.CARD.NOS.AND.LOCK:
*****************************
*updating REDO.CARD.NUMBERS and REDO.CARD.NO.LOCK table
    GOSUB READ.REDO.CARD.NUMBERS
    IF R.REDO.CARD.NUMBERS THEN
        IF Y.NEW.CARD.NO EQ '' THEN
            Y.STATUS=''
        END
        ELSE
            LOCATE Y.NEW.CARD.NO IN R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER,1> SETTING STATUS.POS THEN
                Y.STATUS=R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS,STATUS.POS>
            END
        END

        IF Y.STATUS EQ 'INUSE' OR LEN(Y.STATUS) EQ 0 THEN
            LOCATE 'AVAILABLE' IN R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS,1> SETTING Y.AVAILABLE.CARD.POS THEN
                Y.NXT.AVAILABLE.CARD = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER,Y.AVAILABLE.CARD.POS>

                Y.CARD.LOCK.LIST = R.REDO.CARD.NO.LOCK<REDO.CARD.LOCK.CARD.NUMBER>
                Y.NEW.CARD.LOCK.LIST = INSERT(Y.CARD.LOCK.LIST,1,1;Y.NXT.AVAILABLE.CARD)
                R.REDO.CARD.NO.LOCK<REDO.CARD.LOCK.CARD.NUMBER> = Y.NEW.CARD.LOCK.LIST
                WRITE R.REDO.CARD.NO.LOCK TO F.REDO.CARD.NO.LOCK,Y.CARD.NO.AND.LOCK.ID
                COMI = Y.CARD.TYPE:'.':Y.NXT.AVAILABLE.CARD
            END
        END

        RETURN

*--------------------------------------------------------------------------------------------------------

    END
