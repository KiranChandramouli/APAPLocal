$PACKAGE APAP.TAM
SUBROUTINE V.REDO.COL.TYPE.TELF.UPDATE
******************************************************************************
*
*    This rutine have to register the tracking in the phones updates
*    when any is doing in phone information
* =============================================================================
*
*    First Release : mgudino@temenos.com
*    Developed for :
*    Developed by  :
*    Date          :2010/11/15
*
*    History Changes
*            2010-12-16 : HD1051521
*                         File Descriptor Not Initialized
** 19-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 19-04-2023 Skanda R22 Manual Conversion - No changes
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.COL.TRACE.PHONE
*
*************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ====== TRY TO OPEN THE .PHONE FILE WITH THE CUSTOMER ID
*
*

* HD1051521 S
* F.REDO.COL.TRACE changed by F.REDO.COL.TRACE.PHONE
    CALL F.READ(FN.REDO.COL.TRACE.PHONE, Y.CUSTOMER.ID, R.REDO.COL.TRACE.PHONE, F.REDO.COL.TRACE.PHONE, Y.ERR)
* HD1051521 E

    Y.CLI.TELF.TYPE = R.NEW(EB.CUS.LOCAL.REF)<1,Y.CLI.TELF.TYPE.POS>
    NRO.REL.CODE.TEL = DCOUNT(Y.CLI.TELF.TYPE,@SM)

    Y.INPUTTER = R.NEW(EB.CUS.INPUTTER)
    Y.CUS.UPDT.DATE.TIME = R.NEW(EB.CUS.DATE.TIME)
    Y.CUS.CREAT.DATE.TIME = R.NEW(EB.CUS.AUDIT.DATE.TIME)

***SECOND  CASE DELETE<desc>

    Y.CLI.TELF.TYPE.OLD = R.REDO.COL.TRACE.PHONE<2>
    NRO.REL.CODE.TEL.OLD = DCOUNT(Y.CLI.TELF.TYPE.OLD,@VM)

    FOR I.VAR = 1 TO NRO.REL.CODE.TEL.OLD ;* R22 Auto conversion
*
        FIND R.REDO.COL.TRACE.PHONE<REDO.COL.TP.PHONE.TYPE,I.VAR>  IN  R.NEW(EB.CUS.LOCAL.REF)<1,Y.CLI.TELF.TYPE.POS> SETTING FMPOST THEN ;* BY PHONE.TYPE ;* R22 Auto conversion
*
        END ELSE
            DEL R.REDO.COL.TRACE.PHONE<REDO.COL.TP.PHONE.TYPE,I.VAR> ;* R22 Auto conversion
            DEL R.REDO.COL.TRACE.PHONE<REDO.COL.TP.PHONE.NUMBER,I.VAR> ;* R22 Auto conversion
            DEL R.REDO.COL.TRACE.PHONE<REDO.COL.TP.CREATION.DATE,I.VAR> ;* R22 Auto conversion
            DEL R.REDO.COL.TRACE.PHONE<REDO.COL.TP.LAST.UPD.DATE,I.VAR> ;* R22 Auto conversion
            DEL R.REDO.COL.TRACE.PHONE<REDO.COL.TP.LAST.IMPUTTER,I.VAR> ;* R22 Auto conversion
        END
    NEXT I.VAR ;* R22 Auto conversion
*</desc>

***FIRST CASE UPDATE AND CREATE <desc>


    FOR I.VAR = 1 TO NRO.REL.CODE.TEL ;* R22 Auto conversion
        Y.COD.PHONE.NEW = R.NEW(EB.CUS.LOCAL.REF)<1,Y.CLI.TELF.AREA.POS,I.VAR>:R.NEW(EB.CUS.LOCAL.REF)<1,Y.CLI.TELF.NO.POS,I.VAR> ;* R22 Auto conversion
*
        FIND Y.CLI.TELF.TYPE<1,1,I.VAR> IN R.REDO.COL.TRACE.PHONE<REDO.COL.TP.PHONE.TYPE> SETTING FMPOST,VMPOST THEN  ;* BY PHONE.TYPE ;* R22 Auto conversion
            Y.COD.PHONE.OLD = R.REDO.COL.TRACE.PHONE<REDO.COL.TP.PHONE.NUMBER,VMPOST> ;* PHONE.NUMBER
            IF Y.COD.PHONE.OLD NE Y.COD.PHONE.NEW THEN
* En este caso se actualizan los datos del registro
                R.REDO.COL.TRACE.PHONE<REDO.COL.TP.PHONE.NUMBER,VMPOST> = Y.COD.PHONE.NEW
* fecha
                R.REDO.COL.TRACE.PHONE<REDO.COL.TP.LAST.UPD.DATE,VMPOST>  = Y.CUS.UPDT.DATE.TIME
* inputter
                R.REDO.COL.TRACE.PHONE<REDO.COL.TP.LAST.IMPUTTER,VMPOST>  = Y.INPUTTER
            END
        END ELSE
            R.REDO.COL.TRACE.PHONE<REDO.COL.TP.PHONE.TYPE,-1> = Y.CLI.TELF.TYPE<1,1,I.VAR> ;* R22 Auto conversion
            R.REDO.COL.TRACE.PHONE<REDO.COL.TP.PHONE.NUMBER,-1> = Y.COD.PHONE.NEW
            R.REDO.COL.TRACE.PHONE<REDO.COL.TP.CREATION.DATE,-1> = Y.CUS.CREAT.DATE.TIME
            R.REDO.COL.TRACE.PHONE<REDO.COL.TP.LAST.UPD.DATE,-1> = Y.CUS.UPDT.DATE.TIME
            R.REDO.COL.TRACE.PHONE<REDO.COL.TP.LAST.IMPUTTER,-1> = Y.INPUTTER
        END
    NEXT I.VAR ;* R22 Auto conversion
*</desc>

    CALL F.WRITE(FN.REDO.COL.TRACE.PHONE,Y.CUSTOMER.ID,R.REDO.COL.TRACE.PHONE)

RETURN
* ---------
INITIALISE:
* ---------
*
    Y.CUSTOMER.ID =ID.NEW

    FN.REDO.COL.TRACE.PHONE = "F.REDO.COL.TRACE.PHONE"
    F.REDO.COL.TRACE.PHONE = ""

*      Y.CUSTOMER.P.TYPE = R.NEW()
    LOC.REF.APPL="CUSTOMER"
    LOC.REF.FIELDS := "L.CU.TEL.TYPE":@VM:"L.CU.TEL.AREA":@VM:"L.CU.TEL.NO"
    CUS.POS = ''

    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,CUS.POS)

    Y.CLI.TELF.TYPE.POS = CUS.POS<1,1>
    Y.CLI.TELF.AREA.POS = CUS.POS<1,2>
    Y.CLI.TELF.NO.POS = CUS.POS<1,3>

    PROCESS.GOAHEAD = 1
*
*
RETURN
*
*
* ---------
OPEN.FILES:
* ---------
*
*
    FN.REDO.COL.TRACE.PHONE = 'F.REDO.COL.TRACE.PHONE'
    F.REDO.COL.TRACE.PHONE = ''
    CALL OPF(FN.REDO.COL.TRACE.PHONE,F.REDO.COL.TRACE.PHONE)
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 1

RETURN
*
END
