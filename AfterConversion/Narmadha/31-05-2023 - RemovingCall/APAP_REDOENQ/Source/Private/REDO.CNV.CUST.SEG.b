$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CNV.CUST.SEG
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------
* Modification History
* DATE            ODR           BY              DESCRIPTION
* 25-08-2011      FS-360       Manju.G          For enquiry REDO.CUSTOMER.VIEW
*
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*----------------------------------------------------------------------------
*------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER

    GOSUB INITIALISE
    GOSUB PROCESS
*
RETURN

INITIALISE:
*************

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN

PROCESS:
**********
    IF O.DATA EQ "BRONZE" THEN
        O.DATA = "BRONCE"
    END

    IF O.DATA EQ "COPPER" THEN
        O.DATA = "COBRE"
    END

    IF O.DATA EQ "GOLD" THEN
        O.DATA = "ORO"
    END

    IF O.DATA EQ "PLATINUM" THEN
        O.DATA = "PLATINO"
    END

    IF O.DATA EQ "BRONZE" THEN
        O.DATA = "PLATA"
    END

RETURN
END
