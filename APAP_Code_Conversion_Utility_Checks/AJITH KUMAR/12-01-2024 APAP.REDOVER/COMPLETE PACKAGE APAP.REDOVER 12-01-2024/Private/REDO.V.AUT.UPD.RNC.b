* @ValidationCode : MjoyNDYyMzYyNjI6Q3AxMjUyOjE2ODI0MTIzMzc4MjQ6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUT.UPD.RNC
********************************* **********************************************************************************
*Company   Name    : Asociaciopular de Ahorros y Pramos Bank
*Developed By      : MGUDINO(mgudino@temenos.com)
*Date              : 19 9 2014
*Program   Name    : REDO.V.AUT.UPD.RNC
*------------------------------------------------------------------------------------------------------------------

*Description       : This subroutine get the RNC value.

*In  Parameter     : -NA-
*Out Parameter     : -NA-
*------------------------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                          FM TO @FM
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*---------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_GTS.COMMON
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_BROWSER.TAGS
    $INSERT I_REDO.V.VAL.CED.IDENT.COMMON
    $INSERT JBC.h


    GOSUB INIT

    GOSUB PROCESS

    GOSUB OPEN.FILES

    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------------------------------------------------
INIT:
*****

    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER = ''
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER= ''

    LOC.INTERFACE = ''
    FLAG.SET = 1  ; FLAG = ''
    Y.APPLICATIONS = 'SECURITY.MASTER':@FM:'CUSTOMER'
    LREF.FIELDS = 'L.EMISOR':@FM:'L.CU.RNC'

    CALL MULTI.GET.LOC.REF(Y.APPLICATIONS,LREF.FIELDS,Y.LREF.POS)
* Get the position RNC field in SECURITY.MASTER
    Y.EMISOR.POS = Y.LREF.POS<1,1>

    Y.CUS.RNC = Y.LREF.POS<2,1>

* Get the value Issuer from Customer|
    Y.ISSUER = R.NEW(SC.SCM.ISSUER)

    R.SECURITY.MASTER = ''
    R.CUSTOMER = ''

RETURN
*-------------------------------------------------------------------------------------------------------------------
OPEN.FILES:
***********
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN
*-------------------------------------------------------------------------------------------------------------------

PROCESS:
*******

*----------------------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.CUSTOMER,Y.ISSUER,R.CUSTOMER,F.CUSTOMER,Y.ACC.ERR)

    IF R.CUSTOMER THEN
        Y.CUSTOMER.RNC = R.CUSTOMER<EB.CUS.LOCAL.REF, Y.CUS.RNC>
        R.NEW(SC.SCM.LOCAL.REF)<1, Y.EMISOR.POS> = Y.CUSTOMER.RNC
    END

RETURN
*-------------------------------------------------------------------------
END
*------------------------------------------------------------------------
