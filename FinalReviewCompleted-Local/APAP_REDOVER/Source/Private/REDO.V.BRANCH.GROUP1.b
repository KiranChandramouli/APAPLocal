* @ValidationCode : MjotMjA3NTcyOTExOTpDcDEyNTI6MTY4MjQxMjM0MTc5NDpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.BRANCH.GROUP1
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.TELLER.PROCESS table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.TEL.GROUP
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*27-05-2011     Sudharsanan S       PACS00062653    Initial Creation
* -----------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*--------------------------------------------------------------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.H.MAIN.COMPANY
    $INSERT I_F.REDO.H.ORDER.DETAILS
    $INSERT I_F.REDO.H.REASSIGNMENT
    $INSERT I_GTS.COMMON

    GOSUB INIT
    GOSUB PROCESS


RETURN
*---
INIT:
*---

    FN.REDO.H.ORDER.DETAILS = 'F.REDO.H.ORDER.DETAILS'
    F.REDO.H.ORDER.DETAILS = ''
    CALL OPF(FN.REDO.H.ORDER.DETAILS,F.REDO.H.ORDER.DETAILS)
    FN.REDO.H.MAIN.COMPANY ='F.REDO.H.MAIN.COMPANY'
    F.REDO.H.MAIN.COMPANY = ''
    CALL OPF(FN.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY)

RETURN
*---------------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------------

    Y.GROUP = COMI

    SEL.CMD.1 = 'SELECT ':FN.REDO.H.MAIN.COMPANY
    CALL EB.READLIST(SEL.CMD.1,SEL.LIST.1,'',NO.OF.RECS,DEP.ERR)
    LOOP
        REMOVE Y.ID FROM SEL.LIST.1 SETTING POS.LI
    WHILE Y.ID:POS.LI
        IF Y.GROUP EQ Y.ID THEN

            CALL F.READ(FN.REDO.H.MAIN.COMPANY,Y.GROUP,R.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY,Y.ERR)
            Y.CODE = R.REDO.H.MAIN.COMPANY<REDO.COM.CODE>
            Y.DES = R.REDO.H.MAIN.COMPANY<REDO.COM.DESCRIPTION>
            CHANGE @VM TO '_' IN Y.CODE
            CHANGE @VM TO '_' IN Y.DES
            T(RE.ORD.BRANCH.TRAN.DES) = "":@FM:Y.DES
            SEL.LIST.1 = ''
        END ELSE
            T(RE.ORD.BRANCH.TRAN.DES)<3>= 'NOINPUT'
        END
    REPEAT
RETURN

END
