* @ValidationCode : Mjo2NTEyNDMzNDM6Q3AxMjUyOjE2ODE3MTA3MDI1NjI6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Apr 2023 11:21:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BRANCH.CARD.RETURN.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.DAMAGE.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Description  :*this is the authorisation routine to move the value of card numbers entered to old numbers so
*when user enters next time same user wll get a fresh screen
*Linked With  : Application REDO.BRANCH.CARD.RETURN.AUTHORISE
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 17 Apr 2011    Balagurunathan      ODR-2010-03-0400         Initial Creation
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.BRANCH.CARD.RETURN

***********************************************************************************************
    R.NEW(REDO.BRA.RTN.CARD.NUMBER.OLD)<1,-1> = R.NEW(REDO.BRA.RTN.CARD.NUMBER)
    R.NEW(REDO.BRA.RTN.DESCRIPTION.OLD)<1,-1> = R.NEW(REDO.BRA.RTN.DESCRIPTION)
    R.NEW(REDO.BRA.RTN.CARD.NUMBER)=''
    R.NEW(REDO.BRA.RTN.DESCRIPTION)=''
************************************************************************************************
RETURN
END
