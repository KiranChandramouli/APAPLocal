* @ValidationCode : MjotMTU0OTU3MDkyMTpDcDEyNTI6MTY4NTUyNjk4MTExNzp2aWN0bzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 15:26:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.FX.MTD(Y.OUT.VAR)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Pradeep S
*Program   Name    :REDO.DS.FX.MTD
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the value from EB.LOOKUP TABLE
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $USING APAP.REDOEB

    GOSUB PROCESS

RETURN

*********
PROCESS:
*********

    Y.LOOKUP.ID   = "FX.PAY.RCP.MTD"
    Y.LOOOKUP.VAL = Y.OUT.VAR
    Y.DESC.VAL    = ''
*CALL APAP.REDOEB.REDO.EB.LOOKUP.LIST(Y.LOOKUP.ID,Y.LOOOKUP.VAL,Y.DESC.VAL,RES1,RES2)
    APAP.REDOEB.redoEbLookupList(Y.LOOKUP.ID,Y.LOOOKUP.VAL,Y.DESC.VAL,RES1,RES2) ;* MANUAL R22 CODE CONVERSION

    Y.OUT.VAR = Y.DESC.VAL

RETURN

END
