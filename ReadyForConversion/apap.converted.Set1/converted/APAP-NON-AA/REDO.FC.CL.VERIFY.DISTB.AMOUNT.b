******************************************************************************
SUBROUTINE REDO.FC.CL.VERIFY.DISTB.AMOUNT

******************************************************************************
* Company Name:   Asociacion Popular de Ahorro y Prestamo (APAP)
* Developed By:   Reginal Temenos Application Management
* ----------------------------------------------------------------------------
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose : Check all pre-requirements to collateral balance registry
*
* Incoming        : NA
* Outgoing        : NA
*
* ----------------------------------------------------------------------------
*
*
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : June 26 2011


******************************************************************************
******************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_REDO.FC.COMMON
    $INSERT I_F.REDO.FC.CL.BALANCE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
******************************************************************************

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN

* =========
INITIALISE:
* =========
    LOOP.CNT        = 1
    MAX.LOOPS       = 1
    PROCESS.GOAHEAD = 1

    DES.AA.ID  = R.NEW(REDO.FC.ID.ARRANGEMENT)
    DES.AMOUNT = R.NEW(REDO.FC.DIS.AMT.TOT)

    FN.REDO.FC.CL.BALANCE = 'F.REDO.FC.CL.BALANCE'
    F.REDO.FC.CL.BALANCE = ''

RETURN

* =========
OPEN.FILES:
* =========
    CALL OPF(FN.REDO.FC.CL.BALANCE,F.REDO.FC.CL.BALANCE)

RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
        END CASE
        LOOP.CNT +=1
    REPEAT

RETURN
* ======
PROCESS:
* ======
    CALL F.READ(FN.REDO.FC.CL.BALANCE,DES.AA.ID,R.REDO.FC.CL.BALANCE,F.REDO.FC.CL.BALANCE,ERR.MSJ)

    IF R.REDO.FC.CL.BALANCE THEN
        DES.AMOUNT.AA      = R.REDO.FC.CL.BALANCE<FC.CL.AA.AMOUNT>
        DES.AMOUNT.BALANCE = R.REDO.FC.CL.BALANCE<FC.CL.AA.BALANCE>
        DES.AMOUNT.TOTAL   = DES.AMOUNT.AA - DES.AMOUNT.BALANCE

* Controla que el desembolso realizado no sea mayor
* al cupo disponible del prestamo
        IF DES.AMOUNT GT DES.AMOUNT.TOTAL THEN
            AF = REDO.FC.DIS.AMT.TOT
            ETEXT = "EB-FC.DOES.NOT.SUFFICIENT.CREDIT"
            CALL STORE.END.ERROR
            CALL TRANSACTION.ABORT


        END



    END

RETURN

END
