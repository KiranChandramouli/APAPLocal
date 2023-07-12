SUBROUTINE REDO.B.CLEAR.CHQ.LOAD
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.CLEAR.CHQ.LOAD
*--------------------------------------------------------------------------------------------------------
*Description  :
*
*Linked With  : Main routine REDO.B.CLEAR.CHQ
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 23 Nov 2010    Mohammed Anies K      ODR-2010-09-0251       Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.TFS.PROCESS
    $INSERT I_F.REDO.CLEARING.OUTWARD
    $INSERT I_REDO.B.CLEAR.CHQ.COMMON
    $INSERT I_F.T24.FUND.SERVICES
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    FN.REDO.CLEARING.OUTWARD = 'F.REDO.CLEARING.OUTWARD'
    F.REDO.CLEARING.OUTWARD = ''
    CALL OPF(FN.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD)

    FN.REDO.TRANSIT.LOCK = 'F.REDO.INTRANSIT.LOCK'
    F.REDO.TRANSIT.LOCK = ''
    CALL OPF(FN.REDO.TRANSIT.LOCK,F.REDO.TRANSIT.LOCK)

    FN.ALE = 'F.AC.LOCKED.EVENTS'
    F.ALE = ''
    CALL OPF(FN.ALE,F.ALE)

    LREF.APP='ACCOUNT':@FM:'T24.FUND.SERVICES':@FM:'AZ.ACCOUNT'
    LREF.FIELD='L.AC.TRAN.AVAIL':@FM:'L.TT.PROCESS':@FM:'L.AZ.IN.TRANSIT'
    LREF.POS = ''

    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    L.TRAN.AVAIL.POS = LREF.POS<1,1>
    POS.TT.PROCESS = LREF.POS<2,1>
    POS.IN.TRANSIT = LREF.POS<3,1>

    FN.REDO.GAR.LOCK.ALE='F.REDO.GAR.LOCK.ALE'
    F.REDO.GAR.LOCK.ALE=''
    CALL OPF(FN.REDO.GAR.LOCK.ALE,F.REDO.GAR.LOCK.ALE)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.BATCH = 'F.BATCH'
    FF.BATCH  = ''
    CALL OPF(FN.BATCH,FF.BATCH)

    FN.REDO.INTRANSIT.CHQ = 'F.REDO.INTRANSIT.CHQ'
    F.REDO.INTRANSIT.CHQ = ''
    CALL OPF(FN.REDO.INTRANSIT.CHQ,F.REDO.INTRANSIT.CHQ)

    FN.REDO.TFS.PROCESS = 'F.REDO.TFS.PROCESS'
    F.REDO.TFS.PROCESS = ''
    CALL OPF(FN.REDO.TFS.PROCESS,F.REDO.TFS.PROCESS)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.TFS = 'F.T24.FUND.SERVICES'
    F.TFS = ''
    CALL OPF(FN.TFS,F.TFS)

    BATCH.ID = 'BNK/REDO.B.CLEAR.CHQ.ONLINE'

    Y.JOB.NAME = 'REDO.B.CLEAR.CHQ'
*--------------------------------------------------------------------------------------------------------
RETURN

END
