* @ValidationCode : Mjo3NjQ4NjQ5MTU6Q3AxMjUyOjE2ODA2MDI0NDgwNTg6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2023 15:30:48
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.AUT.CONV.NAME
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    : REDO.APAP.AUT.CONV.NAME
*Reference Number  : ODR-2010-08-0179
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the name and format them
* Date                  who                   Reference              
* 04-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 04-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.H.SOLICITUD.CK

    GOSUB OPENFILE
    GOSUB PROCESS
RETURN

OPENFILE:
    FN.REDO.H.SOLICITUD.CK = 'F.REDO.H.SOLICITUD.CK'
    F.REDO.H.SOLICITUD.CK = ''
    CALL OPF(FN.REDO.H.SOLICITUD.CK,F.REDO.H.SOLICITUD.CK)

PROCESS:

    CALL F.READ(FN.REDO.H.SOLICITUD.CK,ID,R.REDO.H.SOLICITUD.CK,F.REDO.H.SOLICITUD.CK,SOLICITUD.ERR)
    VAR.NAME = R.REDO.H.SOLICITUD.CK<REDO.H.SOL.AUTHORISER>
    O.DATA = FIELD(VAR.NAME,'_',2)

RETURN
END
