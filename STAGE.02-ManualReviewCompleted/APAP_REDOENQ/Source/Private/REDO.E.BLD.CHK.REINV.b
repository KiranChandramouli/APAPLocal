$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.CHK.REINV(ENQ.DATA)
*---------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: NAVEENKUMAR N
* PROGRAM NAME: REDO.E.BLD.CHK.REINV
* ODR NO      : ODR-2010-08-0192
*----------------------------------------------------------------------
* DESCRIPTION:   This is a Build routine attached to the Enquiry
*                REDO.ENQ.CUS.BAD.REFERENCE
* IN PARAMETER : ENQ.DATA
* OUT PARAMETER: ENQ.DATA
* LINKED WITH  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE        WHO            REFERENCE         DESCRIPTION
* 25.08.2010  NAVEENKUMAR N  ODR-2010-08-0192  INITIAL CREATION
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM , VM to @VM and CONVERT to CHANGE
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*----------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.RESTRICTIVE.LIST
*
    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****
* Initialisation of necessary variables
    FN.ACCOUNT        = "F.ACCOUNT"
    F.ACCOUNT         = ""
    R.ACCOUNT         = ""
    E.ACCOUNT         = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
    FN.AZ.ACCOUNT     = "F.AZ.ACCOUNT"
    F.AZ.ACCOUNT      = ""
    R.AZ.ACCOUNT      = ""
    E.AZ.ACCOUNT      = ""
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
*
    Y.ACCEPT.LIST     = ""
    MATURITY.POS      = ""
    ID.POS            = ""
    MATURITY.DATE.VAL = ""
    Y.IDS             = ""
    Y.NULL            = " "
RETURN
********
PROCESS:
********
* Process to find the field value of L.AC.REINVESTED is Yes if not then display must be stopped
*
    GOSUB MULTI.LOC
*
    ENQ.SEL = ENQ.DATA<2>
    CHANGE @VM TO @FM IN ENQ.SEL
*
    LOCATE "@ID" IN ENQ.SEL SETTING ID.POS THEN
        Y.IDS = ENQ.DATA<4,ID.POS>
    END
*
    LOCATE "MATURITY.DATE" IN ENQ.SEL SETTING MATURITY.POS THEN
        MATURITY.DATE.VAL = ENQ.DATA<4,MATURITY.POS>
    END
*
    IF Y.IDS EQ "" THEN
        SEL.CMD   = 'SELECT ':FN.AZ.ACCOUNT
        SEL.LIST  = ""
        NO.OF.REC = ""
        SEL.RET   = ""
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.RET)
        GOSUB LOOP.PROCESS
    END ELSE
        Y.SINGLE = Y.IDS
        CALL F.READ(FN.ACCOUNT,Y.SINGLE,R.ACCOUNT,F.ACCOUNT,E.ACCOUNT)
        Y.L.AC.REINVESTED = R.ACCOUNT<AC.LOCAL.REF,L.AC.REINVESTED.POS>
        IF Y.L.AC.REINVESTED EQ "YES" THEN
            Y.ACCEPT.LIST := Y.SINGLE:@FM
        END
    END
*
    CHANGE @FM TO Y.NULL IN Y.ACCEPT.LIST     ;*R22 Auto Conversion  - CONVERT TO CHANGE
*
    ENQ.DATA<2,1> = "MATURITY.DATE"
    ENQ.DATA<2,2> = "@ID"
    IF MATURITY.DATE.VAL EQ "" THEN
        ENQ.DATA<3,1> = "NE"
    END ELSE
        ENQ.DATA<3,1> = "EQ"
    END
    ENQ.DATA<3,2> = "EQ"
    ENQ.DATA<4,1> = MATURITY.DATE.VAL
    ENQ.DATA<4,2> = Y.ACCEPT.LIST
RETURN
*************
LOOP.PROCESS:
*************
    LOOP
        REMOVE Y.SINGLE FROM SEL.LIST SETTING POSITION
    WHILE Y.SINGLE:POSITION
        CALL F.READ(FN.ACCOUNT,Y.SINGLE,R.ACCOUNT,F.ACCOUNT,E.ACCOUNT)
        Y.L.AC.REINVESTED  = R.ACCOUNT<AC.LOCAL.REF,L.AC.REINVESTED.POS>
        IF Y.L.AC.REINVESTED EQ "YES" THEN
            Y.ACCEPT.LIST := Y.SINGLE:@FM
        END
    REPEAT
RETURN
**********
MULTI.LOC:
**********
* Process to get the position of local reference field value
    APPLICATION.ID      = 'ACCOUNT'
    FIELD.NAME          = 'L.AC.REINVESTED'
    FIELD.POS           = ''
    CALL MULTI.GET.LOC.REF(APPLICATION.ID,FIELD.NAME,FIELD.POS)
    L.AC.REINVESTED.POS = FIELD.POS<1,1>
RETURN
END
