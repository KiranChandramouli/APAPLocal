SUBROUTINE LAPAP.PRD.LIST.OTHER.PRODUCTS

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.CR.OTHER.PRODUCTS
    $INSERT I_F.REDO.CUST.PRD.LIST


    FN.PRD = "F.REDO.CUST.PRD.LIST"
    F.PRD = ""
    CALL OPF(FN.PRD,F.PRD)

    FN.OTHER = "F.CR.OTHER.PRODUCTS"
    F.OTHER = ""
    CALL OPF(FN.OTHER,F.OTHER)

    CUSTOMER  = COMI
    PRODUCT = ID.NEW
    ARR<PRD.PRODUCT.ID> = PRODUCT
    ARR<PRD.PRD.STATUS> = "ACTIVE"
    ARR<PRD.TYPE.OF.CUST> = "CUSTOMER"
    ARR<PRD.DATE> = TODAY
    ARR<PRD.PROCESS.DATE> = TODAY


    CALL F.READ(FN.PRD,CUSTOMER,R.PRD,F.PRD,ERR.PRD)
    UU = R.PRD<PRD.PRODUCT.ID>

    M.VAR = DCOUNT(UU,@VM)
    P = M.VAR+1

    IF R.PRD<PRD.PRODUCT.ID,M.VAR> NE PRODUCT THEN

        R.PRD<PRD.PRODUCT.ID,P> = PRODUCT
        R.PRD<PRD.PRD.STATUS,P> = "ACTIVE"
        R.PRD<PRD.TYPE.OF.CUST,P> = "CUSTOMER"
        R.PRD<PRD.DATE,P> = TODAY


        IF ERR.PRD THEN
            CALL F.WRITE(FN.PRD,CUSTOMER,ARR)
        END

        IF ERR.PRD EQ "" THEN
            CALL F.WRITE(FN.PRD,CUSTOMER,R.PRD)
            RETURN
        END


*   CALL JOURNAL.UPDATE('')

    END

RETURN


END
