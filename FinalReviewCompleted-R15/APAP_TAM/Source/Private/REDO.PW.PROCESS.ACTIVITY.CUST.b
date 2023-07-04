* @ValidationCode : MjotNTg5NjQ3MjY2OkNwMTI1MjoxNjgwOTQwNzExNzc1OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Apr 2023 13:28:31
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
SUBROUTINE  REDO.PW.PROCESS.ACTIVITY.CUST(R.DATA,L.CUST.ID)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This PW routine will map the customer Id

* INPUT/OUTPUT:
*--------------
* IN  : R.DATA
* OUT : L.CUST.ID
*-------------------------------------------------------------------------
*   Date               who           Reference            Description
* 13-SEP-2011     SHANKAR RAJU     ODR-2011-07-0162      Initial Creation
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_PW.COMMON
    $INSERT I_F.PW.PROCESS

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

INITIALISE:
*----------
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.PW.PROCESS = 'F.PW.PROCESS'
    F.PW.PROCESS = ''
    CALL OPF(FN.PW.PROCESS,F.PW.PROCESS)

    FN.PW.ACTIVITY.TXN = 'F.PW.ACTIVITY.TXN'
    F.PW.ACTIVITY.TXN = ''
    CALL OPF(FN.PW.ACTIVITY.TXN,F.PW.ACTIVITY.TXN)

    FN.CR.OPPORTUNITY = 'F.CR.OPPORTUNITY'
    F.CR.OPPORTUNITY = ''
    CALL OPF(FN.CR.OPPORTUNITY,F.CR.OPPORTUNITY)

    FN.CR.OPPORTUNITY.DEFINITION = 'F.CR.OPPORTUNITY.DEFINITION'
    F.CR.OPPORTUNITY.DEFINITION = ''
    R.CR.OPPORTUNITY.DEFINITION = ''
    CALL OPF(FN.CR.OPPORTUNITY.DEFINITION,F.CR.OPPORTUNITY.DEFINITION)

RETURN

PROCESS:
*-------
    PROCESS.TXN.ID = PW$ACTIVITY.TXN.ID
    CALL PW.FIND.PROCESS(PROCESS.TXN.ID,PW.PROCESS.ID)        ;* get the PW.PROCESS name
    CALL F.READ(FN.PW.PROCESS,PW.PROCESS.ID,R.PW.PROCESS,F.PW.PROCESS,ERR.PW.PROCESS)
    IF R.PW.PROCESS THEN
        L.CUST.ID = R.PW.PROCESS<PW.PROC.CUSTOMER>
    END

RETURN
END
