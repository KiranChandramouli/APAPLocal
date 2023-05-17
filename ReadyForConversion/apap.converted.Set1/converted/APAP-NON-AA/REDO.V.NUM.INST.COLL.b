SUBROUTINE REDO.V.NUM.INST.COLL

* Subroutine Type : ROUTINE
* Attached to     : REDO.V.NUM.INST.COLL
* Attached as     : ROUTINE
* Primary Purpose : Validate if the account chosed is valid
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
* Error Variables:
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Edwin Charles D
* Date            : 01 Nov 2017
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CREATE.ARRANGEMENT

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN          ;* Program RETURN

PROCESS:
*-------
    Y.DEBIT.ACCT.NO = COMI

    IF Y.DEBIT.ACCT.NO THEN
        R.ACCOUNT = ''; ACC.ERR = '' ; Y.ACT.STATUS = '' ; Y.LOCK.STATUS = ''
        CALL F.READ(FN.ACCOUNT,Y.DEBIT.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        Y.ACT.STATUS = R.ACCOUNT<AC.LOCAL.REF,POS.L.STATUS.1>
        Y.LOCK.STATUS = R.ACCOUNT<AC.LOCAL.REF,POS.L.STATUS.2>
        BEGIN CASE
            CASE Y.ACT.STATUS[3,8] EQ 'INACTIVE'
                AF = REDO.FC.NUM.INST.COLL.DI
                ETEXT = 'EB-ACCOUNT.IS.INVALD.STATUS'
                CALL STORE.END.ERROR
                RETURN

            CASE Y.LOCK.STATUS EQ 'DECEASED' OR Y.LOCK.STATUS EQ 'GARNISHMENT' OR Y.LOCK.STATUS EQ 'GUARANTEE.STATUS'
                AF = REDO.FC.NUM.INST.COLL.DI
                ETEXT = 'EB-ACCOUNT.RECORD.LOCKED'
                CALL STORE.END.ERROR
                RETURN

            CASE 1

        END CASE
    END

RETURN

*---------
INITIALISE:
*=========

    LOC.REF.APPLICATION = "ACCOUNT"
    LOC.REF.FIELDS = 'L.AC.STATUS1':@VM:'L.AC.STATUS2'
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.STATUS.1 = LOC.REF.POS<1,1>
    POS.L.STATUS.2 = LOC.REF.POS<1,2>

RETURN
*------------------------
OPEN.FILES:
*=========

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

RETURN
*------------
END
