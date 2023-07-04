* @ValidationCode : Mjo2NDIzNzY5ODc6Q3AxMjUyOjE2ODE5OTU5ODY2MTA6SVRTUzotMTotMToxODc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Apr 2023 18:36:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 187
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.ID.CLIENT.NUM
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Pradeep M
* Program Name : REDO.E.CUSTOMER.NAU
*-----------------------------------------------------------------------------
* Description :Built routine to assign value to set variable
* Linked with :
* In Parameter :
* Out Parameter :
*
**DATE          DEVELOPER           ODR              VERSION
*-----------------------------------------------------------------------------
* 13-APR-2023     Conversion tool   R22 Auto conversion   VM to @VM, = to EQ
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON

    CUS.ID = O.DATA
    O.DATA = ""

    GOSUB OPEN.PROCESS
    GOSUB PROCESS

RETURN
*-----------
OPEN.PROCESS:
*-----------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    LREF.APP ='CUSTOMER'
    LREF.FIELDS  = "L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.FOREIGN":@VM:"L.CU.TIPO.CL"
    LOCAL.REF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LOCAL.REF.POS)

    POS.L.CU.CIDENT  = LOCAL.REF.POS<1,1>
    POS.L.CU.RNC     = LOCAL.REF.POS<1,2>
    POS.L.CU.FOREIGN = LOCAL.REF.POS<1,3>
    POS.L.CU.TIPO.CL = LOCAL.REF.POS<1,4>

RETURN

PROCESS:
*=======

    CALL F.READ(FN.CUSTOMER, CUS.ID, R.CUSTOMER, F.CUSTOMER, CUS.ERR)

    Y.TIPO.CL    = R.CUSTOMER<EB.CUS.LOCAL.REF, POS.L.CU.TIPO.CL>
    Y.CU.CIDENT  = R.CUSTOMER<EB.CUS.LOCAL.REF, POS.L.CU.CIDENT>
    Y.CU.RNC     = R.CUSTOMER<EB.CUS.LOCAL.REF, POS.L.CU.RNC>
    Y.CU.FOREIGN = R.CUSTOMER<EB.CUS.LOCAL.REF, POS.L.CU.FOREIGN>

    BEGIN CASE
        CASE Y.TIPO.CL EQ "PERSONA FISICA"
            O.DATA = Y.CU.CIDENT
        CASE Y.TIPO.CL EQ "PERSONA JURIDICA"
            O.DATA = Y.CU.RNC
        CASE (Y.CU.CIDENT EQ "") AND (Y.CU.RNC EQ "")
            O.DATA = Y.CU.FOREIGN
    END CASE

RETURN
END
