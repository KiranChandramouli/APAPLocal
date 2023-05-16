* @ValidationCode : MjoxMzYyMTIwNDU0OkNwMTI1MjoxNjg0MTQ5NjQzMjc4OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 May 2023 16:50:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.CUS.IDENT.INFO
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion -CALL RTN FORMAT MODIFIED
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER

    Y.CUSTOMER = O.DATA
    CUS.IDENT = ""
    IDENT.TYPE = ""
    CUS.ID = ""
    NAME = ""
    LASTN = ""
    DEFV = ""

**---------------------------------------
**ABRIR LA TABLA CUSTOMER
**---------------------------------------
    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""
    R.CUS = ""
    CUS.ERR = ""
    CALL OPF(FN.CUS,FV.CUS)

    CALL F.READ(FN.CUS, Y.CUSTOMER, R.CUS, FV.CUS, CUS.ERR)
*CALL LAPAP.CUSTOMER.IDENT(Y.CUSTOMER, CUS.IDENT, IDENT.TYPE, NAME, LASTN, DEFV) ;*R22 MANUAL CODE CONVERSION
    CALL APAP.LAPAP.lapapCustomerIdent(Y.CUSTOMER, CUS.IDENT, IDENT.TYPE, NAME, LASTN, DEFV) ;*R22 MANUAL CODE CONVERSION

    O.DATA = CUS.IDENT : "*" : IDENT.TYPE

RETURN

END
