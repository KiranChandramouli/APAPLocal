* @ValidationCode : MjotNTM4NDgzMDc3OlVURi04OjE2ODU1MzEyNjU1MjY6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 16:37:45
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.GET.CCARD.DETAILS(Y.FINAL.ARRAY)
*---------------------------------------------------------------------------------
* This is aenquiry for list the details of credit card
*this enquiry will fetch the data from sunnel interface
*---------------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : Prabhu N
* Program Name   : REDO.E.GET.CCARD.DETAILS
* ODR NUMBER     : SUNNEL-CR
* LINKED WITH    : ENQUIRY-REDO.CCARD.DETAILS
*---------------------------------------------------------------------------------
*IN = N/A
*OUT = Y.FINAL.ARRAY
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*3.12.2010     ODR-2010-11-0211      Prabhu N                Initial creation
*02/11/2010    PACS00146408          PRABHUN                 MODIFICATION
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN , VM to @VM , FM to @FM , SM to @SM and ++ to +=
* 11-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $USING APAP.REDOVER

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INITIALISE:
*---------------------------------------------------------------------------------

    FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
    F.REDO.EB.USER.PRINT.VAR=''
    CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)
    Y.ADDITI0NAL.CARD.LIST = ''


    LOCATE 'CARD.NO' IN  D.FIELDS SETTING Y.POS THEN
        Y.CARD.NO=D.RANGE.AND.VALUE<Y.POS>
    END
    Y.D.FIELDS =D.FIELDS
    Y.D.RANGE.AND.VALUE=D.RANGE.AND.VALUE
    D.FIELDS = 'CARD.NO'
    D.RANGE.AND.VALUE=Y.CARD.NO
    Y.ARRAY='BE_K_TC.SP_GET_ADICIONAL_CARDS'
    APAP.REDOVER.redoVWrapSunnel(Y.ARRAY);*R22 Manual Conversion
    Y.ADDITI0NAL.CARD.LIST  = Y.ARRAY<2>
    Y.ADDITI0NAL.CARD = DCOUNT(Y.ADDITI0NAL.CARD.LIST,@VM)

    D.FIELDS =Y.D.FIELDS
    D.RANGE.AND.VALUE=Y.D.RANGE.AND.VALUE
    Y.ARRAY='BE_K_TC.BE_P_RESCUENTATC_A'
    APAP.REDOVER.redoVWrapSunnel(Y.ARRAY);*R22 Manual Conversion



*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    IF ENQ.SELECTION<1,1> EQ 'AI.REDO.CCARD.DETAILS' THEN
        IF Y.ARRAY<1> NE 'SUCCESS' THEN
            ENQ.ERROR='EB-SUNNEL.VAL.FAIL'
            RETURN
        END
    END ELSE
        IF Y.ARRAY<28> NE '0' THEN
            ENQ.ERROR='EB-SUNNEL.VAL.FAIL'
            RETURN
        END
    END

    IF Y.ADDITI0NAL.CARD THEN
        CHANGE @VM TO @FM IN Y.ADDITI0NAL.CARD.LIST
        CHANGE @SM TO @VM IN Y.ADDITI0NAL.CARD.LIST
        LOOP
        WHILE Y.ADD.INT LE Y.ADDITI0NAL.CARD
            Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
            IF E EQ "EB-UNKNOWN.VARIABLE" THEN     ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
                Y.USR.VAR = ""
            END

            Y.USR.VAR = Y.USR.VAR:"-":"CURRENT.ADD.CARD.LIST.CUS"
            Y.ARRAY.ADD.CARD.LIST<-1> = Y.ADDITI0NAL.CARD.LIST<Y.ADD.INT,1>
            Y.ADD.INT += 1
        REPEAT

*    WRITE Y.ARRAY.ADD.CARD.LIST TO F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ;*Tus Start
        CALL F.WRITE(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,Y.ARRAY.ADD.CARD.LIST);*Tus End
    END


*    Y.CARD.NO = System.getVariable('CURRENT.CARD.NO')
    Y.CURRENT.ADD.CARDS =System.getVariable('CURRENT.CARD.LIST')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN     ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CURRENT.ADD.CARDS = ""
    END
    CHANGE @SM TO @FM IN Y.CURRENT.ADD.CARDS
*    Y.CURRENT.COMP.CODE=System.getVariable('CURRENT.COMP.CODE')
    LOCATE 'CARD.NO' IN  D.FIELDS SETTING Y.POS THEN
        Y.CARD.NO=D.RANGE.AND.VALUE<Y.POS>
    END
    Y.CUSTOMER =System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN     ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CUSTOMER = ""
    END

    LOCATE 'COMPANY.CODE' IN  D.FIELDS SETTING Y.POS THEN
        Y.CURRENT.COMP.CODE=D.RANGE.AND.VALUE<Y.POS>
    END
    LOCATE Y.CARD.NO IN Y.CURRENT.ADD.CARDS SETTING Y.SUR.POS THEN
        DEL Y.CURRENT.ADD.CARDS<Y.SUR.POS>
    END
    Y.CNT=1
    LOOP
        REMOVE Y.CURRENT.ADD.CARD FROM Y.CURRENT.ADD.CARDS SETTING Y.ADD.POS
        IF ENQ.SELECTION<1,1> EQ 'AI.REDO.CCARD.DETAILS' THEN

            Y.CARD.NO<1,Y.CNT> = Y.CARD.NO
        END
        Y.FINAL.ARRAY=Y.CARD.NO<1,Y.CNT>:'*':Y.ARRAY<4,Y.CNT>:'*':Y.ARRAY<3,Y.CNT>:'*':Y.ARRAY<12,Y.CNT>:'*':Y.ARRAY<13,Y.CNT>:'*':Y.ARRAY<20,Y.CNT>:'*':Y.ARRAY<27,Y.CNT>:'*':Y.CUSTOMER<1,Y.CNT>:'*':Y.ADDITI0NAL.CARD:'*':Y.CURRENT.ADD.CARD
    WHILE Y.CURRENT.ADD.CARD:Y.ADD.POS
        Y.CNT += 1
    REPEAT
RETURN
END
*------------------------------*END OF SUBROUTINE*--------------------------------
