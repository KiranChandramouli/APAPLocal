* @ValidationCode : MjoxNjQ0NTUyNjE2OkNwMTI1MjoxNjgzODA1ODA0MzMzOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 May 2023 17:20:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

SUBROUTINE REDO.CREDIT.CUSTOMER.POSITION(Y.FINAL.ARRAY)
*------------------------------------------------------------------------
*Description : This routine is nofile enquiry routine in order to fetch the
* credit card details of the customer

*------------------------------------------------------------------------
* Input Argument : NA
* Out Argument   : Y.FINAL.ARRAY
* Deals With     : ENQUIRY>REDO.CREDIT.CUSTOMER.POSITION
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO         REFERENCE            DESCRIPTION
* 03-MAR-2011     H GANESH  ODR-2010-10-0045 N.107   Initial Draft
* 13-05-2011      GANESH H  PACS00063129             MODIFICATION
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - SM TO @SM, FM TO @FM, VM TO @VM, + TO = 1, New condition added
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_System
    $INSERT I_ENQUIRY.COMMON
    $USING APAP.REDOVER

    GOSUB INIT

    GOSUB PROCESS
RETURN

*-------------------------------------------------------
INIT:
*-------------------------------------------------------
* Variables and files are opened here
    FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
    F.REDO.EB.USER.PRINT.VAR=''
    CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)
    CARD.LIST.NUMBER=''

    CLIENT.ID = System.getVariable("EXT.SMS.CUSTOMERS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN         ;** R22 Auto Conversion - Start
        CLIENT.ID = ""
    END                                        ;** R22 Auto Conversion - End
    Y.ARRAY='BE_K_TC.BE_P_CONSOLIDADOTC'
    
*  CALL APAP.REDOVER.REDO.V.WRAP.SUNNEL(Y.ARRAY) ;** R22 Manual conversion - CALL method format changed
    CALL APAP.REDOVER.redoVWrapSunnel(Y.ARRAY) ;*R22 Manual Conversion
RETURN
*-------------------------------------------------------
PROCESS:
*-------------------------------------------------------

    Y.ALL.DATA=Y.ARRAY<4>
    IF Y.ARRAY<2> NE '0' THEN
        ENQ.ERROR='EB-SUNNEL.VAL.FAIL'
        RETURN
    END
    LOCATE 'CLIENT.ID' IN D.FIELDS SETTING POS1 THEN
        Y.CUS.ID= D.RANGE.AND.VALUE<POS1>
    END
    Y.FINAL.ARRAY=''
    CHANGE @VM TO @FM IN Y.ALL.DATA
    CHANGE @SM TO @VM IN Y.ALL.DATA
    Y.DATA.CNT=DCOUNT(Y.ALL.DATA,@FM)

    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.DATA.CNT
        Y.ALL=Y.ALL.DATA<Y.VAR1>

*PACS00063129-S
        CUSTOMER.CARD.LIST<-1>=Y.ALL<1,5>
*  CALL System.setVariable("CURRENT.CARD.LIST.CUS",CUSTOMER.CARD.LIST)
        Y.FINAL.ARRAY<-1>=Y.ALL<1,1>:'*':Y.ALL<1,2>:'*':Y.ALL<1,3>:'*':Y.ALL<1,4>:'*':Y.ALL<1,5>:'*':Y.ALL<1,6>:'*':Y.ALL<1,7>:'*':Y.ALL<1,8>:'*':Y.ALL<1,9>:'*':Y.ALL<1,10>:'*':Y.ALL<1,11>:'*':Y.ALL<1,12>:'*':Y.ALL<1,13>:'*':Y.ALL<1,14>:'*':Y.ALL<1,15>
        Y.VAR1 += 1        ;** R22 Auto conversion - + TO = 1
    REPEAT
    CHANGE @FM TO '*' IN CUSTOMER.CARD.LIST
*    CALL System.setVariable("CURRENT.CARD.LIST.CUS",CUSTOMER.CARD.LIST)


    Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN    ;** R22 Auto Conversion - Start
        Y.USR.VAR = ""
    END                                   ;** R22 Auto Conversion - End

    Y.USR.VAR = Y.USR.VAR:"-":"CURRENT.CARD.LIST.CUS"

*  WRITE CUSTOMER.CARD.LIST TO F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ;*Tus Start
    CALL F.WRITE(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,CUSTOMER.CARD.LIST) ;*Tus End
*PACS00063129-E

RETURN
END
