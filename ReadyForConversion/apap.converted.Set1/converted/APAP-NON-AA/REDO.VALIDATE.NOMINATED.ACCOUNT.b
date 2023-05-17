SUBROUTINE REDO.VALIDATE.NOMINATED.ACCOUNT
***********************************************************************
* DEVELOPED BY: SIMBU
* PROGRAM NAME: REDO.VALIDATE.NOMINATED.ACCOUNT
* ODR NO      : PACS00583537
*----------------------------------------------------------------------
*DESCRIPTION: This is a validation routine to check NOMINATED.ACCOUNT field of the version AZ.ACCOUNT,NOR.PRECLOSURE is active or not.


*IN PARAMETER  : NA
*OUT PARAMETER : NA
*LINKED WITH   : NA
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*16-MAR-2017   SIMBU         PACS005835376  INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT


    GOSUB OPENFILES
    GOSUB VALIDATE.ACCOUNT
RETURN
*---------------------------------------------------
OPENFILES:
*---------------------------------------------------

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    R.ACCOUNT=''

    LOC.REF.APPL="ACCOUNT"
    LOC.REF.FIELDS="L.AC.STATUS1"
    LOC.REF.POS=""
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    Y.STATUS.POS  =  LOC.REF.POS<1,1>

RETURN
*---------------------------------------------------
VALIDATE.ACCOUNT:
*---------------------------------------------------
    Y.ACCOUNT = ""
    ERR.ACCOUNT = ""
    DURATION = ""
    ERROR.TEXT = ""
    STATUS.TEXT = ""
    Y.ACCOUNT = R.NEW(AZ.NOMINATED.ACCOUNT)
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    ACCOUNT.STATUS = R.ACCOUNT<AC.LOCAL.REF,Y.STATUS.POS>
    IF ACCOUNT.STATUS AND ACCOUNT.STATUS NE "ACTIVE" THEN
        YEARS.MONTHS = ACCOUNT.STATUS[2,1]
        DURATION = ACCOUNT.STATUS[1,2]
        BEGIN CASE
            CASE DURATION EQ "AB"
                STATUS.TEXT = "Abandoned"
                ERROR.TEXT = "Below Account is Abandoned"
            CASE YEARS.MONTHS EQ "Y"
                STATUS.TEXT = ACCOUNT.STATUS[1,1]: ' years'
                ERROR.TEXT = 'Below Account is inactive for ':STATUS.TEXT
            CASE YEARS.MONTHS EQ "M"
                STATUS.TEXT = ACCOUNT.STATUS[1,1]: ' months'
                ERROR.TEXT = 'Below Account is inactive for ':STATUS.TEXT
        END CASE
        AF = AZ.NOMINATED.ACCOUNT
        ETEXT =  ERROR.TEXT
        CALL STORE.END.ERROR
    END
RETURN
*---------------------------------------------------


END
