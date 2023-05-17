SUBROUTINE REDO.V.VAL.FR.CLAIM.PRDT.TYPE
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.V.VAL.FR.CLAIM.PRDT.TYPE
*--------------------------------------------------------------------------------
* Description: This Validation routine is used to check on what product does the
* customer logs the request.
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE         WHO         REFERENCE         DESCRIPTION
* 24-May-2011   Pradeep S   PACS00071941      INITIAL CREATION
*
*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_EB.TRANS.COMMON
    $INSERT I_F.REDO.FRONT.CLAIMS

    IF MESSAGE EQ 'VAL' OR cTxn_CommitRequests EQ 1 THEN
        RETURN
    END

    GOSUB PRE.PROCESS
RETURN

PRE.PROCESS:
*************
    IF COMI THEN
        GOSUB PROCESS
    END ELSE
        R.NEW(FR.CL.CLAIM.TYPE) = ''
        R.NEW(FR.CL.DOC.NAME) = ''
        R.NEW(FR.CL.DOC.REV) = ''
        ETEXT = 'EB-MAND.INP'
        CALL STORE.END.ERROR
    END

RETURN

PROCESS:
*********

    BEGIN CASE

        CASE COMI EQ 'TARJETA.DE.CREDITO'
            T(FR.CL.ACCOUNT.ID)<3> = 'NOINPUT'
            N(FR.CL.CARD.NO) := '.1'
            R.NEW(FR.CL.ACCOUNT.ID) = ''
        CASE COMI EQ 'OTROS'
            R.NEW(FR.CL.ACCOUNT.ID) = ''
            R.NEW(FR.CL.CARD.NO) = ''
        CASE 1
            T(FR.CL.CARD.NO)<3> = 'NOINPUT'
            N(FR.CL.ACCOUNT.ID) := '.1'
            R.NEW(FR.CL.CARD.NO) = ''
    END CASE

RETURN

END
