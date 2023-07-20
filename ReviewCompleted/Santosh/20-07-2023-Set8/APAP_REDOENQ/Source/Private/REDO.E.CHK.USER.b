* @ValidationCode : MjozOTgzODM3MjY6Q3AxMjUyOjE2ODk4NDEwMzI1MDI6SVRTUzE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Jul 2023 13:47:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CHK.USER(ENQ.DATA)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used to fetch selection data for the enquiry REDO.TELLER.PROCESS.LIST
*------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 23-04-2010        Prabhu.N          N.78               Initial Creation
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,FM TO @FM
*13-07-2023    VICTORIA S          R22 MANUAL CONVERSION   VARIABLE NAME MODIFIED
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.USER.ACCESS
    $INSERT I_F.REDO.TELLER.PROCESS
    $INSERT I_F.REDO.TELLER.REJECT
    GOSUB INIT
    GOSUB PROCESS
RETURN
*----
INIT:
*----
*Initialise all the vaiables used
*

    FN.USER.ACCESS = 'F.REDO.USER.ACCESS'
    F.USER.ACCESS = ''
*  CALL OPF(FN.USER.ACCESS,F.USER.ACCESS);*Tus (S/E)
    FN.REDO.TELLER.PROCESS='F.REDO.TELLER.PROCESS'
    F.REDO.TELLER.PROCESS=''
    CALL OPF(FN.REDO.TELLER.PROCESS,F.REDO.TELLER.PROCESS)
    FN.REDO.TELLER.REJECT='F.REDO.TELLER.REJECT'
    F.REDO.TELLER.REJECT=''
    CALL OPF(FN.REDO.TELLER.REJECT,F.REDO.TELLER.REJECT)

    VAR.BR.POS = ''
    VAR.ID.POS = ''
RETURN
*-------
PROCESS:
*-------

    LOCATE "BRANCH.CODE" IN ENQ.DATA<2,1> SETTING VAR.BR.POS THEN
        VAR.ACC.VAL = ENQ.DATA<4,VAR.BR.POS>
        IF VAR.ACC.VAL NE ID.COMPANY THEN
*      CALL F.READ(FN.USER.ACCESS,ID.COMPANY,R.REDO.USER.ACC,F.USER.ACCESS,ERR);*Tus Start
            CALL CACHE.READ(FN.USER.ACCESS,ID.COMPANY,R.REDO.USER.ACC,ERR1);*Tus End
            VAR.USER.LIST=R.REDO.USER.ACC<USER.ACC.USER.LIST>
            CHANGE @VM TO @FM IN VAR.USER.LIST ;*R22 AUTO CONVERSION
            LOCATE OPERATOR IN VAR.USER.LIST SETTING OPERATOR.POS ELSE
                ENQ.DATA<3,VAR.BR.POS>='EQ'
                ENQ.DATA<4,VAR.BR.POS>=ID.COMPANY
            END
        END
    END ELSE
        GOSUB PROCESS1
    END

    LOCATE "@ID" IN ENQ.DATA<2,1> SETTING VAR.ID.POS THEN
        VAR.ID=ENQ.DATA<4,VAR.ID.POS>
        IF VAR.ID NE '' THEN
            CALL F.READ(FN.REDO.TELLER.PROCESS,VAR.ID,R.REDO.TELLER.PROCESS,F.REDO.TELLER.PROCESS,ERR)
*VAR.BRANCH.CODE=R.REDO.TELLER.PROCESS<TEL.PRO.BRANCH.CODE> ;*R22 MANUAL CONVERSION : BRANCH.CODE field is missing in appl
            VAR.BRANCH.CODE="" ;*R22 MANUAL CONVERSION
        END
        GOSUB PROCESS2
    END
RETURN
*************************************************************************************************************
PROCESS1:
*************************************************************************************************************
*Checking Branch Field
    VAR.BR.POS=''
*  CALL F.READ(FN.USER.ACCESS,ID.COMPANY,R.REDO.USER.ACC,F.USER.ACCESS,ERR);*Tus Start
    CALL CACHE.READ(FN.USER.ACCESS,ID.COMPANY,R.REDO.USER.ACC,ERR2);*Tus End
    VAR.USER.LIST=R.REDO.USER.ACC<USER.ACC.USER.LIST>
    CHANGE @VM TO @FM IN VAR.USER.LIST ;*R22 AUTO CONVERSION
    LOCATE OPERATOR IN VAR.USER.LIST SETTING OPERATOR.POS ELSE
        Y.FIELD.COUNT=DCOUNT(ENQ.DATA<2>,@VM) ;*R22 AUTO CONVERSION
        Y.COMPANY.CODE = ID.COMPANY
        ENQ.DATA<2,Y.FIELD.COUNT+1> = 'BRANCH.CODE'
        ENQ.DATA<3,Y.FIELD.COUNT+1> = 'EQ'
        ENQ.DATA<4,Y.FIELD.COUNT+1> = Y.COMPANY.CODE
    END

RETURN
***********************************************************
PROCESS2:
***********************************************************
*Checking @ID Field
    IF VAR.BRANCH.CODE NE ID.COMPANY THEN
*    CALL F.READ(FN.USER.ACCESS,ID.COMPANY,R.REDO.USER.ACC,F.USER.ACCESS,ERR);*Tus Start
        CALL CACHE.READ(FN.USER.ACCESS,ID.COMPANY,R.REDO.USER.ACC,ERR3);*Tus End
        VAR.USER.LIST=R.REDO.USER.ACC<USER.ACC.USER.LIST>
        CHANGE @VM TO @FM IN VAR.USER.LIST ;*R22 AUTO CONVERSION
        LOCATE OPERATOR IN VAR.USER.LIST SETTING OPERATOR.POS ELSE
            ENQ.DATA<3,VAR.ID.POS>='EQ'
            ENQ.DATA<4,VAR.ID.POS>=''
        END
    END ELSE
        IF VAR.BR.POS NE '' AND VAR.ACC.VAL NE VAR.BRANCH.CODE THEN
*      CALL F.READ(FN.USER.ACCESS,ID.COMPANY,R.REDO.USER.ACC,F.USER.ACCESS,ERR);*Tus Start
            CALL CACHE.READ(FN.USER.ACCESS,ID.COMPANY,R.REDO.USER.ACC,ERR4);*Tus End
            VAR.USER.LIST=R.REDO.USER.ACC<USER.ACC.USER.LIST>
            CHANGE @VM TO @FM IN VAR.USER.LIST ;*R22 AUTO CONVERSION
            LOCATE OPERATOR IN VAR.USER.LIST SETTING OPERATOR.POS ELSE
                ENQ.DATA<3,VAR.BR.POS>='EQ'
                ENQ.DATA<4,VAR.BR.POS>=VAR.ACC.VAL
            END
        END
    END
RETURN
************************************************************************************************************
END
