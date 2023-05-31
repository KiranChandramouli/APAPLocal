* @ValidationCode : MjotMzQ3ODU5MTkxOkNwMTI1MjoxNjg0NDkxMDM1MDcyOklUU1M6LTE6LTE6LTE5OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -19
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           FM TO @FM, ++ TO +=
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION         CALL routine format modified
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.GET.TOTAL.OUTSTANDING.BYPROP(Y.AA.ID,Y.PROPERTY.LIST,Y.BALANCE.TYPE,Y.TOTAL.AMOUNT)
*-----------------------------------------------------------------
* Description: This routine is to calculate the outstanding balance of Loan by property and balance types.
*-----------------------------------------------------------------
* InComing Arg: ARR.ID         -> Arrangement ID.
*               Y.PROPERTY.LIST-> Property List seperated by FM marker.
*               Y.BALANCE.TYPE -> Balance prefix like ACC,DUE etc seperated by FM marker.
* Outgoing Arg: Y.TOTAL.AMOUNT -> Sum of the amounts.
*-----------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE


    GOSUB INIT
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------
INIT:
*-----------------------------------------------------------------
    Y.TOTAL.AMOUNT= 0
    IN.ACC.ID     = ''
    Y.ACC.ID      = ''
*APAP.TAM.REDO.CONVERT.ACCOUNT(IN.ACC.ID,Y.AA.ID,Y.ACC.ID,ERR.TEXT) ;*MANUAL R22 CODE CONVERSION
    APAP.TAM.redoConvertAccount(IN.ACC.ID,Y.AA.ID,Y.ACC.ID,ERR.TEXT) ;*MANUAL R22 CODE CONVERSION

RETURN
*-----------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------

    Y.BALANCE = 0
    Y.PROPERTY.CNT = DCOUNT(Y.PROPERTY.LIST,@FM)
    Y.BALANCE.CNT  = DCOUNT(Y.BALANCE.TYPE,@FM)
    Y.LOOP1 = 1
    LOOP
    WHILE Y.LOOP1 LE Y.PROPERTY.CNT
        Y.LOOP2 = 1
        LOOP
        WHILE Y.LOOP2 LE Y.BALANCE.CNT

            BALANCE.TO.CHECK = Y.BALANCE.TYPE<Y.LOOP2>:Y.PROPERTY.LIST<Y.LOOP1>
            BALANCE.AMOUNT=''
            CALL AA.GET.ECB.BALANCE.AMOUNT(Y.ACC.ID,BALANCE.TO.CHECK,TODAY,BALANCE.AMOUNT,RET.ERROR)
            Y.BALANCE += ABS(BALANCE.AMOUNT)
            Y.LOOP2 += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
        Y.LOOP1 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
    Y.TOTAL.AMOUNT = Y.BALANCE
RETURN
END
