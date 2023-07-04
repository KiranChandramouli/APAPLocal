* @ValidationCode : MjoxOTIzMzk3MzE6Q3AxMjUyOjE2ODQ4NTQ0MDQwMDM6SVRTUzotMTotMTo5OToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 99
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BLD.ACC.FUNDS.INTRANSIT(ENQ.DATA)

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Sudharsanan S
* Program Name : REDO.BLD.ACC.FUNDS.INTRANSIT
*---------------------------------------------------------

* Description : This build routine is used to get the customer id value based on L.FT.AZ.ACC.REF value
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - ADDED IF E EQ "EB-UNKNOWN.VARIABLE" THEN VARIABLE NULL AND END
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*----------------------------------------------------------
* Linked With :
* In Parameter : None
* Out Parameter : None
*----------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.CLEARING.OUTWARD
    $INSERT I_System

    FN.REDO.CLEARING.OUTWARD = 'F.REDO.CLEARING.OUTWARD'
    F.REDO.CLEARING.OUTWARD  = ''
    CALL OPF(FN.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD)

    Y.VAR.ACCOUNT = System.getVariable('CURRENT.ACCT.NO')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CONVERSTION ADDED IF E EQ "EB-UNKNOWN.VARIABLE" THEN VARIABLE NULL AND END
        Y.VAR.ACCOUNT = ""
    END

    ENQ.DATA<2,-1> = 'CHQ.STATUS'
    ENQ.DATA<3,-1> = 'EQ'
    ENQ.DATA<4,-1> = 'DEPOSITED'

    ENQ.DATA<2,-1> = 'ACCOUNT'
    ENQ.DATA<3,-1> = 'EQ'
    ENQ.DATA<4,-1> = Y.VAR.ACCOUNT

RETURN

END
