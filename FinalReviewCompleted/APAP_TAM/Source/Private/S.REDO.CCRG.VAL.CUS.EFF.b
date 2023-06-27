* @ValidationCode : MjoxNzQwNTkzOTE3OkNwMTI1MjoxNjg0ODQyMTU1MDI4OklUU1M6LTE6LTE6MjI1OjE6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 225
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE S.REDO.CCRG.VAL.CUS.EFF(P.CUSTOMER.ID, P.EFF.TIME, P.ACTION, P.RESULT)
*
*--------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description:
*             This routine allows to check (query) or update information in the live-file
*   REDO.CCRG.RL.EFFECTIVE.CUSTOMER
*   If the action sent was Q, the routine checks if the customer information has  reached
*   the effective date.
*   If the action sent was I, the routine updates the information.
*
* Linked With:
*              REDO.CCRG.B.EXT Service
*
* In Parameter:
* ---------------
*           P.CUSTOMER.ID        (in)  Customer Identifier
*           P.EFF.TIME           (in)  Effective Time expressed in minutes. This is taken from REDO.CCRG.PARAMETERS>EFFECTIVE.TIME
*           P.ACTION             (in)  Action to take, could be (Q)uery o (I)nput
*
* Out Parameter:
* ---------------
*           P.RESULT             (out) When the action is Q, returns @TRUE or FALSE
*           E (i_common)               User message in case of error
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 06/04/2011 - ODR-2011-03-0154
*              First version. Risk Limit for Customer and Group Risk
*              hpasquel@temenos.com
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*19/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION       FM TO @FM, VM TO @VM, X TO X.WAR
*19/04/2023         SURESH           MANUAL R22 CODE CONVERSION      CALL routine format modified
*--------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_REDO.CCRG.CONSTANT.COMMON
    $INSERT I_F.REDO.CCRG.RL.EFFECTIVE.CUSTOMER
*
*--------------------------------------------------------------------------------------------
*


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN
*
*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------
    BEGIN CASE
        CASE P.ACTION EQ  "Q"
            GOSUB QUERY.EFFECTIVE
        CASE P.ACTION EQ  "I"
            GOSUB UPDATE.EFFECTIVE
    END CASE

RETURN
*--------------------------------------------------------------------------------------------
QUERY.EFFECTIVE:
*--------------------------------------------------------------------------------------------

*
* Read Customer.Effective record
    YERR = ''
    R.RCREC = ''
    CALL F.READ(FN.REDO.CCRG.RL.EFFECTIVE.CUSTOMER,P.CUSTOMER.ID,R.RCREC,F.REDO.CCRG.RL.EFFECTIVE.CUSTOMER,YERR)
    IF R.RCREC EQ '' THEN
        P.RESULT = @FALSE
        RETURN
    END
*
* Get the end.date according startDate and EffectiveTime
*
    Y.START.DATE = R.RCREC<REDO.CCRG.RLEC.START.DATE>
    APAP.TAM.sRedoAddTime(Y.START.DATE, Y.END.DATE, P.EFF.TIME) ;*MANUAL R22 CODE CONVERSION

* Compare with current Time
*
    GOSUB GET.CUR.TIME
    P.RESULT = Y.END.DATE GE Y.CUR.TIME

RETURN
*--------------------------------------------------------------------------------------------
UPDATE.EFFECTIVE:
*--------------------------------------------------------------------------------------------
    R.RCREC = ''
*
* Get Current Time
*
    GOSUB GET.CUR.TIME
*
* Create and write record
*
    R.RCREC<REDO.CCRG.RLEC.START.DATE> = Y.CUR.TIME
    CALL F.WRITE(FN.REDO.CCRG.RL.EFFECTIVE.CUSTOMER,P.CUSTOMER.ID,R.RCREC)

RETURN
*--------------------------------------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------------------------------------
    FN.REDO.CCRG.RL.EFFECTIVE.CUSTOMER = 'F.REDO.CCRG.RL.EFFECTIVE.CUSTOMER'
    F.REDO.CCRG.RL.EFFECTIVE.CUSTOMER = ''
    CALL OPF(FN.REDO.CCRG.RL.EFFECTIVE.CUSTOMER,F.REDO.CCRG.RL.EFFECTIVE.CUSTOMER)
RETURN

*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------

    LOOP.CNT         = 1
    MAX.LOOPS        = 3
    PROCESS.GOAHEAD  = @TRUE

RETURN


*--------------------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*--------------------------------------------------------------------------------------------

    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF P.CUSTOMER.ID EQ "" THEN
                    E = K.PARAMETER.IS.EMPTY : @FM : "P.CUSTOMER.ID" : @VM : "S.REDO.CCRG.VAL.CUS.EFF"
                    PROCESS.GOAHEAD = @FALSE
                END
            CASE LOOP.CNT EQ 2
                IF NOT(P.ACTION MATCHES "Q" : @VM : "I") THEN
                    E = K.INVALID.ARGS :
                    E<2> = P.ACTION : @VM : "P.ACTION" : @VM : "S.REDO.CCRG.VAL.CUS.EFF" : "Q,I"
                    PROCESS.GOAHEAD = @FALSE
                END
            CASE LOOP.CNT EQ 3
                IF  P.ACTION EQ "Q" AND P.EFF.TIME EQ "" THEN
                    E = K.PARAMETER.IS.EMPTY : @FM : "P.EFF.TIME" : @VM : "S.REDO.CCRG.VAL.CUS.EFF"
                    PROCESS.GOAHEAD = @FALSE
                END
        END CASE

        LOOP.CNT +=1
    REPEAT

RETURN

*--------------------------------------------------------------------------------------------
GET.CUR.TIME:
*--------------------------------------------------------------------------------------------
* Get Current Time on GLOBUS.FORMAT
*
    Y.TIM.STAMP = TIMEDATE()
    X.VAR = OCONV(DATE(),"D-") ;*AUTO R22 CODE CONVERSION
    Y.CUR.TIME = X.VAR[9,2]:X.VAR[1,2]:X.VAR[4,2]:Y.TIM.STAMP[1,2]:Y.TIM.STAMP[4,2] ;*AUTO R22 CODE CONVERSION

RETURN
*--------------------------------------------------------------------------------------------
END
