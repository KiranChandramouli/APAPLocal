SUBROUTINE REDO.FC.CL.ACCOUNTING.VALIDATE

*-----------------------------------------------------------------------------

* Developer    : mgudino

* Date         : 25.01.2013

* Description  : Validate the parametericed accounts

*-----------------------------------------------------------------------------

* Modification History:

*

* Version   Date            Who               Reference      Description



*-----------------------------------------------------------------------------

* Input/Output:

* None/None

*

* Dependencies: NA

*-----------------------------------------------------------------------------





* <region name="INCLUDES">

    $INSERT I_COMMON

    $INSERT I_EQUATE



    $INSERT I_F.COLLATERAL

    $INSERT I_F.CUSTOMER

    $INSERT I_F.STMT.ENTRY



    $INSERT I_F.ACCOUNT



    $INSERT I_F.REDO.COLLATERAL.PARAMETER

* </region>



    GOSUB INIT

    GOSUB OPEN.FILES

    GOSUB PROCESS



RETURN



* <region name="INIT" description="Initialise">

INIT:

    Y.PGM = 'COLLATERAL'



    Y.BASE.ENTRY = ''

    Y.ENTRY      = ''

    Y.ENTRY.REC  = ''



    Y.CL.CUSTOMER = ''

    Y.ACC.OFFICER = ''

    Y.DEPART.CODE = ''



    Y.CL.AMOUNT        = ''

    Y.CR.CATEGORY.CODE = ''

    Y.DB.CATEGORY.CODE = ''

    Y.CR.INT.ACCOUNT   = ''

    Y.DB.INT.ACCOUNT   = ''

    Y.CR.TRX           = ''

    Y.DB.TRX           = ''



    Y.COLLATERAL = ID.NEW



    FN.CUSTOMER = 'F.CUSTOMER'

    F.CUSTOMER  = ''

    R.CUSTOMER  = ''



    FN.REDO.COLLATERAL.PARAMETER = 'F.REDO.COLLATERAL.PARAMETER'

    F.REDO.COLLATERAL.PARAMETER  = ''

    R.REDO.COLLATERAL.PARAMETER  = ''



    FN.COLLATERAL= 'F.COLLATERAL$HIS'

    F.COLLATERAL= ''

    R.COLLATERAL= ''



    FN.ACCOUNT = 'F.ACCOUNT'

    F.ACCOUNT = ''





    Y.VALIDATE.ACCOUNTS = 1

    Y.ERR = ''

* To permit interact with contingents accouts in the actual application

    COMMON/CONTINGENT.APPS/APP.LIST

    YPOS = ""

    LOCATE APPLICATION IN APP.LIST<1> SETTING YPOS ELSE

        INS APPLICATION BEFORE APP.LIST<YPOS>

    END



RETURN

* </region>



* <region name="OPEN.FILES" description="Open Files">

OPEN.FILES:

    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    CALL OPF(FN.REDO.COLLATERAL.PARAMETER, F.REDO.COLLATERAL.PARAMETER)

    CALL OPF(FN.COLLATERAL, F.COLLATERAL)

    CALL OPF(FN.ACCOUNT, F.ACCOUNT)



RETURN

* </region>



* <region name="PROCESS" description="Main Process">

PROCESS:

    GOSUB OBTAIN.ACC.DETAILS

RETURN

* </region>

* <region name="OBTAIN.ACC.DETAILS" description="Obtain Accounting Info">

OBTAIN.ACC.DETAILS:



    Y.COLL.CODE = R.NEW(COLL.COLLATERAL.CODE)

    Y.CL.AMOUNT = R.NEW(COLL.GEN.LEDGER.VALUE)



    CALL CACHE.READ(FN.REDO.COLLATERAL.PARAMETER,Y.COLL.CODE,R.REDO.COLLATERAL.PARAMETER,Y.ERR)



* Obtener la informacion de acuerdo al tipo de COLLATERAL

    Y.CL.TYPE.NUM = DCOUNT(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.COLLATERAL.TYPE>,@VM)

    I.VAR = 1

    LOOP

    WHILE I.VAR LE Y.CL.TYPE.NUM

        Y.CL.TYPE = FIELD(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.COLLATERAL.TYPE>,@VM,I.VAR)

        IF Y.CL.TYPE EQ R.NEW(COLL.COLLATERAL.TYPE) THEN

            Y.CR.CATEGORY.CODE = FIELD(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.CR.CATEGORY.CODE>,@VM,I.VAR)

            Y.DB.CATEGORY.CODE = FIELD(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.DB.CATEGORY.CODE>,@VM,I.VAR)



            Y.CR.TRX = FIELD(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.CR.TRX.CODE>,@VM,I.VAR)

            Y.DB.TRX = FIELD(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.DB.TRX.CODE>,@VM,I.VAR)



            Y.CY.NUM = DCOUNT(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.CURRENCY,I.VAR>,@SM)

            GOSUB  OBTAIN.ACC.DETAILS2



        END

        I.VAR += 1

    REPEAT



    Y.ACCOUNT = Y.CR.INT.ACCOUNT

    Y.ERR = ''

    R.ACCOUNT.DB = ''

    R.ACCOUNT.CR = ''



    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT.CR,F.ACCOUNT,Y.ERR)

    IF NOT(R.ACCOUNT.CR) THEN

        Y.VALIDATE.ACCOUNTS = 0

    END



    Y.ACCOUNT = Y.DB.INT.ACCOUNT

    Y.ERR = ''

    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT.DB,F.ACCOUNT,Y.ERR)

    IF NOT(R.ACCOUNT.DB) THEN

        Y.VALIDATE.ACCOUNTS = 0

    END



    IF R.ACCOUNT.CR<AC.CONTINGENT.INT> NE R.ACCOUNT.DB<AC.CONTINGENT.INT> THEN

        Y.VALIDATE.ACCOUNTS = 0

    END

    IF NOT(Y.VALIDATE.ACCOUNTS) THEN
        AF = COLL.COLLATERAL.TYPE
        ETEXT = "EB-FC-COLL.ACCOUNTING"
        CALL STORE.END.ERROR
        RETURN
    END

RETURN

OBTAIN.ACC.DETAILS2:

    J.VAR = 1

    LOOP

    WHILE J.VAR LE Y.CY.NUM

        Y.CY = FIELD(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.CURRENCY,I.VAR>,@SM,J.VAR)

        IF Y.CY EQ R.NEW(COLL.CURRENCY) THEN

            Y.CR.INT.ACCOUNT   = FIELD(R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.CR.INT.ACCOUNT,I.VAR>,@SM,J.VAR)

            Y.DB.INT.ACCOUNT   = R.REDO.COLLATERAL.PARAMETER<REDO.CL.PR.DB.INT.ACCOUNT,I.VAR,J.VAR>

        END

        J.VAR += 1

    REPEAT

RETURN

* </region>



END
