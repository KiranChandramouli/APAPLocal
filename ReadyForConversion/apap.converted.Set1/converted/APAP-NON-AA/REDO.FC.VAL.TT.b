SUBROUTINE REDO.FC.VAL.TT
*
* Subroutine Type : ROUTINE
* Attached to     :
* Attached as     : ROUTINE
* Primary Purpose :
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : mgudino - TAM Latin America
* Date            :
*
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
*Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*Tus End

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END


RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
    Y.I =""
    Y.COUNT=""
    Y.COUNT = DCOUNT(R.NEW(REDO.FC.TYPE.OF.SEC.DI),@VM)
    FOR Y.I = 1 TO Y.COUNT
* Get the account number (fix deposit or deposits )
        VAR.CUENTA = R.NEW(REDO.FC.NUM.INST.COLL.DI)<1,Y.I>     ;* ID INSTRUMENTO
        VAR.TIPO = R.NEW(REDO.FC.SEC.CLASSIFY.DI)<1,Y.I>        ;* CLASE GARANTIA DI

*///ACCOUNTS///
        IF (VAR.TIPO EQ 151) OR (VAR.TIPO EQ 153) THEN
*Get the prymary key customer
            YERROR = ""
            CALL F.READ(FN.ACCOUNT,VAR.CUENTA,R.ACCOUNT,F.ACCOUNT,YERROR)
            R.ECB='' ; ECB.ERR='' ;*Tus Start
            CALL EB.READ.HVT("EB.CONTRACT.BALANCES",VAR.CUENTA,R.ECB,ECB.ERR);*Tus End
            IF YERROR THEN
                ETEXT = "EB-FC-READ.ERROR" : @FM : FN.ACCOUNT
                CALL STORE.END.ERROR
            END ELSE
*  VAR.SALDO =  R.ACCOUNT<AC.WORKING.BALANCE>;*Tus Start
                VAR.SALDO =  R.ECB<ECB.WORKING.BALANCE>;*Tus End
                VAR.BLOQ  =  R.ACCOUNT<AC.LOCKED.AMOUNT>
                R.NEW(REDO.FC.AVAIL.COLL.VAL.DI)<1,Y.I>= VAR.SALDO - VAR.BLOQ
            END
        END


*///FIX DEPOSITS///
        IF (VAR.TIPO EQ 152) THEN
            VAR.TOT.LOCK = 0
*Get the prymary key customer
            YERROR = ""
            CALL F.READ(FN.AZ,VAR.CUENTA,R.AZ,F.AZ,YERROR)
            IF YERROR THEN
                ETEXT = "EB-FC-READ.ERROR" : @FM : FN.ACCOUNT
                CALL STORE.END.ERROR
            END ELSE

*Value of fix deposit
                VAR.VALOR    =  R.AZ<AZ.PRINCIPAL>

                SELECT.STATEMENT = 'SELECT FBNK.AC.LOCKED.EVENTS WITH ACCOUNT.NUMBER LIKE ':VAR.CUENTA
                LOCK.LIST = ''
                LIST.NAME = ''
                SELECTED = ''
                SYSTEM.RETURN.CODE = ''
                Y.ID.AA.PRD = ''
                CALL EB.READLIST(SELECT.STATEMENT,LOCK.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

*GET ALL VALUES FROM THE LIST AND ADD THE LOCK VALUE
                LOOP
                    REMOVE Y.ID.AA.PRD FROM LOCK.LIST SETTING POS
                WHILE Y.ID.AA.PRD:POS

                    CALL CACHE.READ(FN.LOCK1, Y.ID.AA.PRD, R.LOCK1, Y.ERR)

*GET AMOUNT LOCK FOR ACCOUNT
                    VAR.LOCK1    =  R.LOCK1<AC.LCK.LOCKED.AMOUNT>
                    IF VAR.LOCK1 EQ '' THEN
                        VAR.LOCK1 = 0
                    END
                    VAR.TOT.LOCK += VAR.LOCK1

                    IF Y.ERR NE '' THEN
                        P.MESSAGE = 'ERROR AL LEER ':VAR.CUENTA:' EN LA TABLA AC.LOCKED.EVENTS'
                        RETURN
                    END
                REPEAT


*SET THE AVALIABLE VALUE IN THE COLLATERAL
                VAR.TOT.DISPO = VAR.VALOR - VAR.TOT.LOCK

                R.NEW(REDO.FC.AVAIL.COLL.VAL.DI)<1,Y.I> = VAR.TOT.DISPO
            END
        END
    NEXT Y.I

RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
    PROCESS.GOAHEAD = 1

    FN.ACCOUNT   = 'F.ACCOUNT'
    F.ACCOUNT    = ''
    R.ACCOUNT    = ''

    FN.LOCK1      = 'F.AC.LOCKED.EVENTS'
    F.LOCK1       = ''
    R.LOCK1       = ''

    FN.AZ        = 'F.AZ.ACCOUNT'
    F.AZ         = ''
    R.AZ         = ''

*Read the local fields

RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.LOCK1,F.LOCK1)
    CALL OPF(FN.AZ,F.AZ)
RETURN
*------------
END
