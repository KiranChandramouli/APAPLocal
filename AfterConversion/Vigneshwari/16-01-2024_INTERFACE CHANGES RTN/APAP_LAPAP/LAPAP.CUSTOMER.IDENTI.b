* @ValidationCode : MjoxMDM0ODUyMTY0OkNwMTI1MjoxNzA1Mzk2NzQ5NjMxOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Jan 2024 14:49:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
*16-01-2024	                  VIGNESHWARI      			ADDED COMMENT FOR INTERFACE CHANGES          SQA-12394 - By Santiago
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
            COMI = R.CUS<EB.CUS.LOCAL.REF,CARD.ID>	;*Fix SQA-12394 - By Santiago-CHANGED "CARD.ID" TO "R.CUS<EB.CUS.LOCAL.REF,CARD.ID>" 

        CASE NO.UNIC NE ''
            COMI = R.CUS<EB.CUS.LOCAL.REF,NO.UNIC>	;*Fix SQA-12394 - By Santiago-CHANGED "NO.UNIC" TO "R.CUS<EB.CUS.LOCAL.REF,NO.UNIC>"

        CASE B.CERT NE ''
            COMI = R.CUS<EB.CUS.LOCAL.REF,B.CERT>	;*Fix SQA-12394 - By Santiago-CHANGED "B.CERT" TO "R.CUS<EB.CUS.LOCAL.REF,B.CERT>"

        CASE PASS.N NE ''
            COMI = R.CUS<EB.CUS.LOCAL.REF,PASS.N>	;*Fix SQA-12394 - By Santiago-CHANGED "PASS.N" TO "R.CUS<EB.CUS.LOCAL.REF,PASS.N>"

        CASE RNC.NO NE ''
            COMI = R.CUS<EB.CUS.LOCAL.REF,RNC.NO>	;*Fix SQA-12394 - By Santiago-CHANGED "RNC.NO" TO "R.CUS<EB.CUS.LOCAL.REF,RNC.NO>"
            
        CASE 1	;*Fix SQA-12394 - By Santiago-NEW LINE IS ADDED
            COMI = ''	;*Fix SQA-12394 - By Santiago-CHANGED "RNC.NO" TO ''
            

    END CASE

RETURN

END