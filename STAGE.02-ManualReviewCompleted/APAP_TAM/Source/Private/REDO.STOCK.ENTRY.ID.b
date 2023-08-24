* @ValidationCode : MjotMTczOTUxMDY3OTpDcDEyNTI6MTY4MTA5NzczMzc3ODpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 09:05:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.STOCK.ENTRY.ID
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.STOCK.ENTRY.ID
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to to fetch next sequence no from F.LOCKING
*Linked With  : REDO.STOCK.ENTRY
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 21-Jan-2010    Kavitha S             ODR-2010-03-0400        Code change as per CR
* 10.04.2023     Conversion Tool            R22            Auto Conversion     - FM TO @FM, VM TO @VM
* 10.04.2023     Shanmugapriya M            R22            Manual Conversion   - No changes
*
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.USER
    $INSERT I_F.COMPANY
    $INSERT I_F.LOCKING
    $INSERT I_F.REDO.STOCK.ENTRY
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********


    GOSUB OPEN.PARA
    IF NOT(RUNNING.UNDER.BATCH) THEN
        IF GTSACTIVE THEN
            IF OFS$OPERATION EQ 'BUILD' THEN
                GOSUB PROCESS.PARA
                RETURN
            END
        END ELSE
            GOSUB PROCESS.PARA
        END
    END ELSE
        GOSUB PROCESS.PARA
    END
RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened

    FN.STOCK.ENTRY = 'F.REDO.STOCK.ENTRY'
    F.STOCK.ENTRY = ''
    CALL OPF(FN.STOCK.ENTRY,F.STOCK.ENTRY)

    FN.STOCK.ENTRY.NAU = 'F.REDO.STOCK.ENTRY$NAU'
    F.STOCK.ENTRY.NAU = ''
    CALL OPF(FN.STOCK.ENTRY.NAU,F.STOCK.ENTRY.NAU)

    Y.COMPANY = ID.COMPANY
    Y.COMPANY = Y.COMPANY[6,4]

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section
    E = ''

    IF V$FUNCTION NE 'I' THEN
        RETURN
    END

    IF MESSAGE EQ 'VAL' THEN
        RETURN
    END

    Y.REDO.CARD.REQUEST.ID = ID.NEW

    GOSUB CHECK.LIVE

    IF R.STOCK.ENTRY AND V$FUNCTION EQ 'I' THEN
        E='ST-STOCK.ENTRY.ID.ERR'
        CALL STORE.END.ERROR

    END

RETURN
*--------------------------------------------------------------------------------------------------------
CHECK.LIVE:
***********
*

    R.STOCK.ENTRY = ''
    REDO.CARD.REQUEST.ERR = ''
    CALL F.READ(FN.STOCK.ENTRY,Y.REDO.CARD.REQUEST.ID,R.STOCK.ENTRY,F.STOCK.ENTRY,REDO.CARD.REQUEST.ERR)
    IF R.STOCK.ENTRY THEN
        REQ.CO.CODE = R.STOCK.ENTRY<STK.CO.CODE>
        GOSUB CHECK.COMP.ERROR
    END



RETURN
*--------------------------------------------------------------------------------------------------------
CHECK.COMP.ERROR:


    USER.COMP = R.USER<EB.USE.COMPANY.CODE>
    CHANGE @VM TO @FM IN USER.COMP

    FINAL.COMP = R.COMPANY(EB.COM.FINANCIAL.COM)

    IF ID.COMPANY NE REQ.CO.CODE THEN
        IF ID.COMPANY NE FINAL.COMP THEN
            LOCATE ID.COMPANY IN USER.COMP SETTING POS ELSE
                E = "EB-CANNOT.ACCESS.ANOTHER.COMP"
            END
        END
    END


RETURN
*-------------------------------------------------------------------------
END
