SUBROUTINE REDO.V.AUTH.CUS.INDENT
*-----------------------------------------------------------------------------

*------------
*DESCRIPTION:
*-----------------------------------------------------------------------------------------
*  This routine is attached as a authorization routine for the CUSTOMER
*  and it will update REDO.CUS.IDENTIFICATION with id as CIDENT/RNC/PASSPORT and value as
*  CustomerId*IdentificationNo
*------------------------------------------------------------------------------------------

*--------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-

*--------------
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*------------------
* Revision History:
*------------------
*   Date               who           Reference            Description
* 21-APR-2011       Pradeep S        PACS00053452         Initial Creation
* 02-NOV-2011       Pradeep S        PACS00153528         PROSPECT customer will not be considered.
* 18-04-2012        Pradeep S        PACS00190839         Fix for data migration issue
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    GOSUB INIT
    GOSUB PRE.CHECK
RETURN


*------
INIT:
*------
    FN.REDO.CUS.LEGAL.ID = 'F.REDO.CUSTOMER.LEGAL.ID'
    F.REDO.CUS.LEGAL.ID = ''
    CALL OPF(FN.REDO.CUS.LEGAL.ID,F.REDO.CUS.LEGAL.ID)

    Y.CU.LEGAL.ID.OLD = ''

RETURN

*---------
PRE.CHECK:
*---------

    Y.REC.STATUS  = R.NEW(EB.CUS.RECORD.STATUS)
    Y.CURR.NO = R.NEW(EB.CUS.CURR.NO)

    Y.CU.LEGAL.ID = R.NEW(EB.CUS.LEGAL.ID)

    Y.CUS.TYPE = R.NEW(EB.CUS.CUSTOMER.TYPE)
    Y.CUS.TYPE.OLD = R.OLD(EB.CUS.CUSTOMER.TYPE)

    Y.CU.LEGAL.ID.OLD = R.OLD(EB.CUS.LEGAL.ID)

    IF (V$FUNCTION EQ "I") OR (V$FUNCTION EQ "A" AND Y.REC.STATUS[1,2] EQ "IN") THEN
        GOSUB INSERT.PROCESS
    END

    IF (V$FUNCTION EQ "R") OR (V$FUNCTION EQ "A" AND Y.REC.STATUS[1,2] EQ "RN") THEN
        GOSUB DELETE.PROCESS
    END

RETURN

*--------------
INSERT.PROCESS:
*--------------

    Y.ID = Y.CU.LEGAL.ID
    Y.VALUE = ID.COMPANY:"*":ID.NEW

    IF Y.CURR.NO LE 1 AND Y.CU.LEGAL.ID THEN
        GOSUB INS.CONCAT
    END

    IF Y.CU.LEGAL.ID NE Y.CU.LEGAL.ID.OLD AND (Y.CU.LEGAL.ID OR Y.CU.LEGAL.ID.OLD) AND (Y.CURR.NO GT 1) THEN
        IF Y.CU.LEGAL.ID.OLD NE '' THEN
            Y.ID = Y.CU.LEGAL.ID.OLD
            Y.VALUE = ID.COMPANY:"*":ID.NEW
            GOSUB DEL.CONCAT
        END
        IF Y.CU.LEGAL.ID NE '' THEN
            Y.ID = Y.CU.LEGAL.ID
            Y.VALUE = ID.COMPANY:"*":ID.NEW
            GOSUB INS.CONCAT
        END
    END

RETURN

*---------------
DELETE.PROCESS:
*---------------

    Y.ID = Y.CU.LEGAL.ID
    Y.VALUE = ID.COMPANY:"*":ID.NEW

    IF Y.CU.LEGAL.ID THEN
        GOSUB DEL.CONCAT
    END

RETURN
*----------
INS.CONCAT:
*----------

    Y.IDENT.ID = Y.ID

    R.CUS.IDENT = Y.VALUE

    GOSUB WRITE.CUS.IDENT


RETURN

*----------
DEL.CONCAT:
*----------

    Y.IDENT.ID = Y.ID

    CALL F.DELETE(FN.REDO.CUS.LEGAL.ID,Y.IDENT.ID)

RETURN

*--------------
WRITE.CUS.IDENT:
*--------------

    CALL F.WRITE(FN.REDO.CUS.LEGAL.ID,Y.IDENT.ID,R.CUS.IDENT)

RETURN

END
