* @ValidationCode : Mjo4NjMzMjM3MTU6Q3AxMjUyOjE2ODIzMzU5NDMyMTQ6SVRTUzotMTotMTotNzoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.TD.SET.16D
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This AUTO.CONTENT.ROUTINE  is to set CARD NUMBER in LATAM.CARD.ORDER VERSION from ID.NEW
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : ARCADIO RUIZ
* PROGRAM NAME : L.APAP.TD.SET.16D
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 BP NAME REMOVED
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION- BP NAME REMOVED
    $INSERT I_EQUATE ;* AUTO R22 CODE CONVERSION- BP NAME REMOVED
    $INSERT I_F.LATAM.CARD.ORDER ;* AUTO R22 CODE CONVERSION- BP NAME REMOVED

    GOSUB PROCESS
RETURN

PROCESS:
*-------

    R.NEW(CARD.IS.CARD.LINKED) = FIELD(ID.NEW,'.',2)
RETURN
*------------------------------------------------------------------------------------------------------------
END
