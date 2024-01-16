* @ValidationCode : MjoxOTQ2ODQ5MTAxOkNwMTI1MjoxNzAyMzgzMzk5MTUyOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Dec 2023 17:46:39
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
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.CUSTOMER.IDENTI
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*DATE			               AUTHOR					Modification                            DESCRIPTION
*08-12-2023	                  VIGNESHWARI       			ADDED COMMENT FOR INTERFACE CHANGES        SQA-11985- By Santiago-no changes
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    GOSUB INIT
    GOSUB PROCESS


INIT:
*----

    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    CALL OPF(FN.CUS,F.CUS)

    CALL F.READ(FN.CUS,COMI,R.CUS,F.CUS,CUS.ERR)

RETURN


PROCESS:
*-------
    APP.ARR = 'CUSTOMER'
    FIELD.ARR = 'L.CU.CIDENT':@VM:'L.CU.NOUNICO':@VM:'L.CU.ACTANAC':@VM:'L.CU.PASS.NAT':@VM:'L.CU.RNC'
    CALL MULTI.GET.LOC.REF(APP.ARR,FIELD.ARR,POS.ARR)
    CARD.ID = POS.ARR<1,1>
    NO.UNIC = POS.ARR<1,2>
    B.CERT  = POS.ARR<1,3>
    PASS.N  = POS.ARR<1,4>
    RNC.NO  = POS.ARR<1,5>

    BEGIN CASE
        CASE CARD.ID NE ''
            COMI = CARD.ID

        CASE NO.UNIC NE ''
            COMI = NO.UNIC

        CASE B.CERT NE ''
            COMI = B.CERT

        CASE PASS.N NE ''
            COMI = PASS.N

        CASE RNC.NO NE ''
            COMI = RNC.NO

    END CASE

RETURN

END