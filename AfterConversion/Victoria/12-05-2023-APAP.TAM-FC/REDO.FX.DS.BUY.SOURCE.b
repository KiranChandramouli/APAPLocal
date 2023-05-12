* @ValidationCode : MjoxNjMzMzUwNzAzOkNwMTI1MjoxNjgxMTA2NTIwMzQ5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 11:32:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.FX.DS.BUY.SOURCE(IN.OUT.PARA)
*------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This deal slip routine should be attached to the DEAL.SLIP.FORMAT, REDO.BUY.SELL.DSLIP
*------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : PRADEEP S
* PROGRAM NAME : REDO.DS.BUY.SELL.SOURCE
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 29-APR-2011      Pradeep S         PACS00054288                 Initial Creation
* 27-Jun-2012      Pradeep S         PACS00204543                 Language specific chages
*15-FEB-2012       Prabhu N          PACS00249258                modified to eb lookup
** 10-04-2023 R22 Auto Conversion no changes
** 10-04-2023 Skanda R22 Manual Conversion - Call routine added
*----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.USER
    $INSERT I_F.REDO.BUY.SELL.SOURCE
    $USING APAP.REDOEB
    GOSUB PROCESS

RETURN

********
PROCESS:
********
* Getthe description for source ;* R22 Auto conversion

    Y.LOOKUP.ID   = "L.TT.FX.BUY.SRC"
    Y.LOOOKUP.VAL = IN.OUT.PARA
    Y.DESC.VAL    = ''
*CALL REDO.EB.LOOKUP.LIST(Y.LOOKUP.ID,Y.LOOOKUP.VAL,Y.DESC.VAL,RES1,RES2)
*R22 Manual Conversion
    CALL APAP.REDOEB.redoEbLookupList(Y.LOOKUP.ID,Y.LOOOKUP.VAL,Y.DESC.VAL,RES1,RES2)
    IN.OUT.PARA=Y.DESC.VAL

RETURN
END
