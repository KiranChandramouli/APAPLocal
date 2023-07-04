* @ValidationCode : MjoxMDM0MTI4ODY6Q3AxMjUyOjE2ODQ4NTQ0MDQxNDQ6SVRTUzotMTotMTotNzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BLD.DISB.E.AUTHOR(ENQ.DATA)
*------------------------------------------------------------------
*Description: This build is to pass the selection value company code in BRANCH.ID field
*             as we cannot the pass the company code with !ID.COMPANY (It works only for dates like !TODAY)
*------------------------------------------------------------------
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - $INCLUDE TO $INSERT
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON  ;*R22 AUTO CONVERSTION $INCLUDE TO $INSERT
    $INSERT I_EQUATE  ;*R22 AUTO CONVERSTION $INCLUDE TO $INSERT
    $INSERT I_ENQUIRY.COMMON  ;*R22 AUTO CONVERSTION $INCLUDE TO $INSERT

    GOSUB PROCESS

RETURN
*------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------

    LOCATE "BRANCH.ID" IN ENQ.DATA<2,1> SETTING POS1 THEN
        ENQ.DATA<3,POS1> = 'EQ'
        ENQ.DATA<4,POS1> = ID.COMPANY
    END ELSE
        ENQ.DATA<2,POS1> = 'BRANCH.ID'
        ENQ.DATA<3,POS1> = 'EQ'
        ENQ.DATA<4,POS1> = ID.COMPANY
    END

RETURN
END
