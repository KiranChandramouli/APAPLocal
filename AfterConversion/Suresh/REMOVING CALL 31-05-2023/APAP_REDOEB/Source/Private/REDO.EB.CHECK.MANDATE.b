* @ValidationCode : MjozNjczNzk4OkNwMTI1MjoxNjgxOTc5NTk3OTU3OklUU1M6LTE6LTE6MjU2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Apr 2023 14:03:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 256
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE REDO.EB.CHECK.MANDATE(ALLOW.APPROVAL,Y.MAND.GROUP.ID)
*-----------------------------------------------------------------------------
* Routine to check whether the signatories have the right to authorise the
* contract if not contract is moved to  INAO status.
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool    R22 Auto conversion       VM to @VM, ++ to +=
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.SIGNATORY.GROUP
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.REDO.APAP.STO.DUPLICATE
    $INSERT I_F.EB.MANDATE.PARAMETER
    $INSERT I_F.EB.MANDATE
    $INSERT I_System


    GOSUB INIT        ;* initialisation
    GOSUB PROCESS     ;*do the processing

RETURN
*-----------------------------------------------------------------------------

*** <region name= INIT>
INIT:
*** <desc> Initialise the signatory field no:</desc>

    FN.EB.MANDATE = 'F.EB.MANDATE'
    F.EB.MANDATE  = ''
    CALL OPF(FN.EB.MANDATE,F.EB.MANDATE)

    FN.EB.SIGNATORY.GROUP = 'F.EB.SIGNATORY.GROUP'
    F.EB.SIGNATORY.GROUP  = ''
    CALL OPF(FN.EB.SIGNATORY.GROUP,F.EB.SIGNATORY.GROUP)

    FN.EB.MANDATE.PARAMETER = 'F.EB.MANDATE.PARAMETER'
    F.EB.MANDATE.PARAMETER  = ''
    CALL OPF(FN.EB.MANDATE.PARAMETER,F.EB.MANDATE.PARAMETER)


    VALID.SIGNATORY = ""; MAN.CHK = ""    ;* flag to trigger when any one of the mandates has failed
    CALL GET.STANDARD.SELECTION.DETS(APPLICATION,R.STANDARD.SELECTION)  ;*read the standard selction record
    CALL FIELD.NAMES.TO.NUMBERS('SIGNATORY',R.STANDARD.SELECTION,SIGN.FIELD.NO,'','','','','')        ;* get the field no of signatory

RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>Get the Signatory id for processing </desc>

    Y.TXN.AMOUNT = R.NEW(REDO.SO.CURRENT.AMOUNT.BAL)

    IF EB.EXTERNAL$USER.ID THEN ;*if its external user
        ARC.CUST.ID = System.getVariable("EXT.CUSTOMER")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - START
            ARC.CUST.ID = ""
        END					;*R22 Auto conversion - END

        IF R.NEW(SIGN.FIELD.NO) THEN        ;* if both external user and signatory user provided
            SIGN.CUSTOMER.ID = ARC.CUST.ID    ;* else use external user
        END ELSE
            ALLOW.APPROVAL = ''
            RETURN
        END
    END
*
    GOSUB GET.EB.MANDATE.DET

    CHANGE @VM TO @FM IN Y.SIGN.CUST.ARR
    LOCATE ARC.CUST.ID IN Y.SIGN.CUST.ARR SETTING Y.MAND.POS THEN
    END ELSE
        ALLOW.APPROVAL = 1
    END
RETURN
******************
GET.EB.MANDATE.DET:
******************

    CALL CACHE.READ(FN.EB.MANDATE, Y.MAND.GROUP.ID, R.EB.MANDATE, EB.MANDATE.ERR);*R22 Auto conversion
    Y.SIGNATORY.GROUP = R.EB.MANDATE<EB.MAND.SIGNATORY.GROUP>
    Y.MAND.AMOUNT     = R.EB.MANDATE<EB.MAND.UP.TO.AMOUNT>
    Y.SIGN.GRP.TOT = DCOUNT(Y.SIGNATORY.GROUP,@VM)
    Y.SIGN.GRP.INT = 1
    LOOP
    WHILE Y.SIGN.GRP.INT LE Y.SIGN.GRP.TOT
        Y.SIGN.GRP.ID = Y.SIGNATORY.GROUP<1,Y.SIGN.GRP.INT>
        Y.MAND.EACH.AMT = Y.MAND.AMOUNT<1,Y.SIGN.GRP.INT>
        GOSUB  GET.SIGNATORIES.GROUP
        Y.SIGN.GRP.INT += 1
    REPEAT

RETURN
**********************
GET.SIGNATORIES.GROUP:
**********************
    CALL CACHE.READ(FN.EB.SIGNATORY.GROUP, Y.SIGN.GRP.ID, R.EB.SIGNATORY.GROUP, ESG.ERR) ;*R22 Auto conversion
    IF R.EB.SIGNATORY.GROUP THEN
        Y.SIGN.CUST  = R.EB.SIGNATORY.GROUP<EB.SIG.GRP.SIGNATORY.CUSTOMER>
        Y.SIGN.CUST.ARR<-1> = Y.SIGN.CUST
        Y.START.DATE = R.EB.SIGNATORY.GROUP<EB.SIG.GRP.START.DATE>
        Y.END.DATE   = R.EB.SIGNATORY.GROUP<EB.SIG.GRP.END.DATE>


        Y.SIGN.CUST.CNT = 1
        Y.SIGN.CUST.TOT = DCOUNT(Y.SIGN.CUST,@VM)
        LOOP
        WHILE Y.SIGN.CUST.CNT LE Y.SIGN.CUST.TOT
            Y.SIGN.CUST.ID     = Y.SIGN.CUST<1,Y.SIGN.CUST.CNT>
            Y.SIGN.START.DATE  = Y.START.DATE<1,Y.SIGN.CUST.CNT>
            Y.SIGN.END.DATE    = Y.END.DATE<1,Y.SIGN.CUST.CNT>
            IF Y.SIGN.CUST.ID EQ ARC.CUST.ID THEN
                IF TODAY GE Y.SIGN.START.DATE AND TODAY LE Y.SIGN.END.DATE THEN
                    IF Y.MAND.EACH.AMT LT Y.TXN.AMOUNT THEN
                        ALLOW.APPROVAL = 1
                        RETURN
                    END
                END
            END
            Y.SIGN.CUST.CNT += 1
        REPEAT
    END
RETURN
*----------------------------------------------------------------------------------------
END
