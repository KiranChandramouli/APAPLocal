* @ValidationCode : MjoxMTIzNjA4NDE5OkNwMTI1MjoxNjgzODExMTIwMjQ5OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 May 2023 18:48:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.RAD.MON.BENEF.CUSTID.OPER

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
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION         CALL routine format modified
*-----------------------------------------------------------------------------------
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
                Y.RETURN = Y.LEGAL.ID
            CASE Y.L.CU.CIDENT NE ''
                Y.RETURN = Y.L.CU.CIDENT
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
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FIELD.ARRAY,FIELD.POS) ;*MANUAL R22 CODE CONVERSION
    Y.L.CU.CIDENT.POS = FIELD.POS<1,1>
RETURN

*-----------------------------------------------------------------------------------
END
