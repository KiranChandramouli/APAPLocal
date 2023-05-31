* @ValidationCode : MjoxMTA5NjgyODU5OkNwMTI1MjoxNjgyNTA5NjE0MzM0OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Apr 2023 17:16:54
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
** 13-04-2023 R22 Auto Conversion no changes
** 13-04-2023 Skanda R22 Manual Conversion - added APAP.TAM
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
