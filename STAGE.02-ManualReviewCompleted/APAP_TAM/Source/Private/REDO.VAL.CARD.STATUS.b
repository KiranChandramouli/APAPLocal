$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.CARD.STATUS
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.VAL.CARD.STATUS
*--------------------------------------------------------------------------------------------------------
*Description  : This is a validation routine to find out whether the status entered is valid or not
*Linked With  : REDO.CARD.REQUEST,PRINTING
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 30 Jul 2010    Mohammed Anies K      ODR-2010-03-0400         Initial Creation
** 18-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 18-04-2023 Skanda R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.REQUEST
*--------------------------------------------------------------------------------------------------------

    RECORD.STATUS = R.NEW(REDO.CARD.REQ.STATUS)

    GOSUB REGOFF.CHECK
    GOSUB SUPPLY.CHECK
    GOSUB PRINT.CHECK
    GOSUB BRANCH.CHECK
    GOSUB BRANCH.RECEIVED.CHECK

RETURN
*--------------------------------------------------------------------------------------------------------
REGOFF.CHECK:

    IF PGM.VERSION EQ ",REGOFF" THEN ;* R22 Auto conversion
        IF RECORD.STATUS NE 2 THEN
            AF= REDO.CARD.REQ.STATUS
            ETEXT='EB-INVALID.CARD.STATUS':@FM:'ORDER SUBMITTED TO SAP'
            CALL STORE.END.ERROR
        END
    END

RETURN
*---------------------------------------------------------------------
SUPPLY.CHECK:

    IF PGM.VERSION EQ ",SUPPLY" THEN ;* R22 Auto conversion

        IF RECORD.STATUS NE 3 THEN
            AF= REDO.CARD.REQ.STATUS
            ETEXT='EB-INVALID.CARD.STATUS':@FM:'ORDER DELIVERED'
            CALL STORE.END.ERROR

        END

    END

RETURN
*-------------------------------------------------------------------------------
PRINT.CHECK:

    IF PGM.VERSION EQ ",PRINTING" THEN ;* R22 Auto conversion

        IF RECORD.STATUS NE 4 THEN
            AF= REDO.CARD.REQ.STATUS
            ETEXT='EB-INVALID.CARD.STATUS':@FM:'IN PRINTING PROCESS'
            CALL STORE.END.ERROR
        END

    END

RETURN
*------------------------------------------------------------------------
BRANCH.CHECK:

    IF PGM.VERSION EQ ",BRANCH" THEN ;* R22 Auto conversion
        IF RECORD.STATUS NE 5 THEN
            AF= REDO.CARD.REQ.STATUS
            ETEXT='EB-INVALID.CARD.STATUS':@FM:'DELIVERED TO BRANCH'
            CALL STORE.END.ERROR
        END
    END

RETURN
*---------------------------------------------------------------------------------------
BRANCH.RECEIVED.CHECK:

    IF PGM.VERSION EQ ",BRANCH.RECEIVED" THEN ;* R22 Auto conversion
        IF RECORD.STATUS NE 6 THEN
            AF= REDO.CARD.REQ.STATUS
            ETEXT='EB-INVALID.CARD.STATUS':@FM:'RECEIVED TO BRANCH'
            CALL STORE.END.ERROR
        END
    END
RETURN
*----------------------------------------------------------------------------------------
END
