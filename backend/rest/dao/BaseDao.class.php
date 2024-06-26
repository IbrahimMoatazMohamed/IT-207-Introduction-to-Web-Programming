<?php

require_once dirname(__FILE__) . "/../config.php";

class BaseDao
{
    protected $connection;
    protected $table;
    public function __construct($table)
    {
        $this->table = $table;
        try {
            $this->connection = new PDO(
                "mysql:host=" . Config::DB_HOST() . ";dbname=" . Config::DB_NAME() . ";charset=utf8;port=" . Config::DB_PORT(),
                Config::DB_USER(),
                Config::DB_PASS(),
                [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                ]
            );
        } catch (PDOException $e) {
            //TODO return try again later
        }
    }
    public function beginTransaction()
    {
        return $this->connection->beginTransaction();
    }
    public function commit()
    {
        return $this->connection->commit();
    }
    public function rollBack()
    {
        return $this->connection->rollBack();
    }
    protected function query($query, $params)
    {
        $statement = $this->connection->prepare($query);
        $statement->execute($params);
        return $statement->fetchAll(PDO::FETCH_ASSOC);
    }
    protected function query_unique_first($query, $params)
    {
        $results = $this->query($query, $params);
        return reset($results);
    }
    protected function query_unique_last($query, $params)
    {
        $results = $this->query($query, $params);
        return end($results);
    }
    protected function execute($query, $params)
    {
        $prepared_statement = $this->connection->prepare($query);
        if ($params) {
            foreach ($params as $key => $param) {
                $prepared_statement->bindValue($key, $param);
            }
        }
        $prepared_statement->execute();
        return $prepared_statement;
    }
    public function insert($table, $entity)
    {
        $query = "INSERT INTO {$table} (";
        foreach ($entity as $column => $value) {
            $query .= $column . ", ";
        }
        $query = substr($query, 0, -2);
        $query .= ") VALUES (";
        foreach ($entity as $column => $value) {
            $query .= ":" . $column . ", ";
        }
        $query = substr($query, 0, -2);
        $query .= ")";
        $statement = $this->connection->prepare($query);
        $statement->execute($entity);
        $entity['id'] = $this->connection->lastInsertId();
        return $entity;
    }
    protected function getTable()
    {
        return $this->table;
    }
}
