* @ValidationCode : MjotMjAxNzA2OTEzNjpDcDEyNTI6MTY4MTkwNTY4MTE3MjpJVFNTOi0xOi0xOjM3MToxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Apr 2023 17:31:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 371
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.SPOUSE.NAMES(SPOUSE.DET)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2009-10-0547
* This is field format routine for the deal slip CUS.KYC.FORM.1.It will intake the ACCOUNT number
* and sends out the ID.NUM of the customer
* Input/Output:
*--------------
* IN : ACCOUNT.ID
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
* Date who Reference Description
* 25-Nov-2009 SHANKAR RAJU Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES

*------------------------------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS
RETURN
*************
INIT:
*************
    CUS.ID = ID.NEW

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''

    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL GET.LOC.REF('CUSTOMER','L.CU.CIDENT',CIDENT.POS)
RETURN

***********
PROCESS:
***********

    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)

    IF R.CUSTOMER THEN


        REL.CODES=R.CUSTOMER<EB.CUS.RELATION.CODE>

        GOSUB REL.CHECK

    END
RETURN

**********
REL.CHECK:
**********
    IF REL.CODES NE '' THEN

        COUNT.CODE=DCOUNT(REL.CODES,@VM)

        FOR COUNTER.CODE=1 TO COUNT.CODE

            IF R.CUSTOMER<EB.CUS.RELATION.CODE,COUNTER.CODE> EQ 7 OR R.CUSTOMER<EB.CUS.RELATION.CODE,COUNTER.CODE> EQ 8 THEN

                REL.CUS = R.CUSTOMER<EB.CUS.REL.CUSTOMER,COUNTER.CODE>
                GOSUB REL.CUSTOMER

            END
        NEXT COUNTER.CODE
    END
RETURN

*************
REL.CUSTOMER:
*************

    CALL F.READ(FN.CUSTOMER,REL.CUS,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)

    SPOUSE.DET = FMT(R.REL.CUSTOMER<EB.CUS.FAMILY.NAME>,"L#25")

    IF SPOUSE.DET EQ '' THEN

        SPOUSE.DET = ' '
    END

    SPOUSE.DET := ' ':R.REL.CUSTOMER<EB.CUS.GIVEN.NAMES>

RETURN
*-------------------------------------------------------------------------------------------
END
