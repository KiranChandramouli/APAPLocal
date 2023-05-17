SUBROUTINE REDO.RAD.MON.CUSTID.TYPE

*-----------------------------------------------------------------------------
* Primary Purpose: Returns identification and identification type of a customer given as parameter
*                  Used in RAD.CONDUIT.LINEAR as API routine.
* Input Parameters: CUSTOMER.CODE
* Output Parameters: Identification @ Identification type
*-----------------------------------------------------------------------------
* Modification History:
*
* 18/09/10 - Cesar Yepez
*            New Development
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_TSS.COMMON

    GOSUB OPEN.FILES

    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------------
PROCESS:
    CALL F.READ(FN.CUSTOMER, COMI, R.CUSTOMER, F.CUSTOMER, ERR.CUS)

    IF NOT(ERR.CUS) THEN
        Y.LEGAL.ID = R.CUSTOMER<EB.CUS.LEGAL.ID>
        Y.L.CU.CIDENT = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.CIDENT.POS>

        BEGIN CASE
            CASE Y.LEGAL.ID NE ''
                Y.RETURN = 'PAS'
            CASE Y.L.CU.CIDENT NE ''
                Y.RETURN = 'CED'
        END CASE

    END

    COMI = Y.RETURN

RETURN


RETURN
*-----------------------------------------------------------------------------------

OPEN.FILES:
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    APPL.ARRAY = "CUSTOMER"
    FIELD.ARRAY = "L.CU.CIDENT"
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FIELD.ARRAY,FIELD.POS)
    Y.L.CU.CIDENT.POS = FIELD.POS<1,1>
RETURN

*-----------------------------------------------------------------------------------
END
