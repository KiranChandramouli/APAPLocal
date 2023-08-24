* @ValidationCode : MjotMTcyMTcwOTkzMzpDcDEyNTI6MTY4MTgyOTA4OTcxMjpJVFNTOi0xOi0xOi0xNDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Apr 2023 20:14:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -14
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*12-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*12-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
SUBROUTINE REDO.CUS.PROVISION.AUTHORISE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.H.PROVISION.PARAMETER.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.CUS.PROVISION.AUTHORISE is an authorisation routine attached to the TEMPLATE
*                    - REDO.H.CUSTOMER.PROVISIONING;
*Linked With       : TEMPLATE-REDO.H.CUSTOMER.PROVISIONING
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.H.CUSTOMER.PROVISIONING           As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------            ------               -------------               -------------
* 24 Sep 2010        JEEVA T           ODR-2009-11-0159 B.23A        Initial Creation
*******************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.CUSTOMER.PROVISIONING
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB PROCESS.PARA

RETURN
*-------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

    Y.PRINC              = R.NEW(REDO.CUS.PROV.PROV.PRINC)
    Y.PRINC.INT          = R.NEW(REDO.CUS.PROV.PROV.INTEREST)
    Y.PROV.RES           = R.NEW(REDO.CUS.PROV.PROV.RESTRUCT)
    Y.PROV.FX            = R.NEW(REDO.CUS.PROV.PROV.FX)
    Y.TOTOL =Y.PRINC + Y.PRINC.INT + Y.PROV.RES + Y.PROV.FX
    R.NEW(REDO.CUS.PROV.TOTAL.PROV) = Y.PRINC + Y.PRINC.INT + Y.PROV.RES + Y.PROV.FX
RETURN
*-------------------------------------------------------------------------
END
