SUBROUTINE REDO.AUT.UP.AZ.TRANS.REF
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.AUT.UP.AZ.TRANS.REF
* ODR NUMBER    : ODR-2009-10-0795
*----------------------------------------------------------------------------------------------------
* Description   : this is auth routine used to update AZ.ACCOUNT
* In parameter  :
* out parameter :
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 11-01-2011      MARIMUTHU s     ODR-2009-10-0795   Initial Creation
*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.USER


    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    CALL MULTI.GET.LOC.REF('AZ.ACCOUNT','L.FT.REF.NO':@VM:'L.CHQ.PAY.DATE',POS)
    REF.NO = POS<1,1>
    PAY.DTE = POS<1,2>

    CALL BUILD.USER.VARIABLES(Y.DATA)

    Y.STR = FIELD(Y.DATA,@FM,2)

    Y.ACCS = FIELD(Y.STR,'*',2)

    Y.CNT = DCOUNT(Y.ACCS,'-') - 1
    FLG = ''
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
        Y.AC = FIELD(Y.ACCS,'-',FLG)
        CALL F.READ(FN.AZ.ACCOUNT,Y.AC,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
        IF R.AZ.ACCOUNT THEN
            Y.REF = R.AZ.ACCOUNT<AZ.LOCAL.REF,REF.NO>
            IF Y.REF EQ '' THEN
                R.AZ.ACCOUNT<AZ.LOCAL.REF,REF.NO> = ID.NEW
                R.AZ.ACCOUNT<AZ.LOCAL.REF,PAY.DTE> = TODAY
                GOSUB MAKE.AUDIT
            END ELSE
                Y.CNT.VM = DCOUNT(Y.REF,@SM)
                R.AZ.ACCOUNT<AZ.LOCAL.REF,REF.NO,Y.CNT.VM+1> = ID.NEW
                R.AZ.ACCOUNT<AZ.LOCAL.REF,PAY.DTE,Y.CNT.VM+1> = TODAY

                GOSUB MAKE.AUDIT
            END
        END
        Y.CNT -= 1
    REPEAT

RETURN

MAKE.AUDIT:

    TEMPTIME = OCONV(TIME(),"MTS")
    TEMPTIME = TEMPTIME[1,5]
* CONVERT ':' TO '' IN TEMPTIME
    TEMPTIME = CHANGE(TEMPTIME,':','')
    CHECK.DATE = DATE()
    R.AZ.ACCOUNT<AZ.RECORD.STATUS> = ''
    R.AZ.ACCOUNT<AZ.DATE.TIME> = OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):OCONV(CHECK.DATE,"DD"):TEMPTIME
    R.AZ.ACCOUNT<AZ.CURR.NO>= R.AZ.ACCOUNT<AZ.CURR.NO> + 1
    R.AZ.ACCOUNT<AZ.INPUTTER>=C$T24.SESSION.NO:'_':OPERATOR
    R.AZ.ACCOUNT<AZ.AUTHORISER>=C$T24.SESSION.NO:'_':OPERATOR
    R.AZ.ACCOUNT<AZ.DEPT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
    R.AZ.ACCOUNT<AZ.CO.CODE>=ID.COMPANY

    CALL F.WRITE(FN.AZ.ACCOUNT,Y.AC,R.AZ.ACCOUNT)
*  CALL REDO.AZ.WRITE.TRACE('REDO.AUT.UP.AZ.TRANS.REF',Y.AC)
RETURN

END
